#include "GpuTelemetry.h"
#include <QFile>
#include <QDir>
#include <QProcess>
#include <QTimer>

namespace {
// Watchdog: bunuh QProcess yang menggantung (>8 dtk). finished() tetap
// terpanggil → parse gagal anggun → nilai terakhir dipertahankan.
void armWatchdog(QProcess *p, int ms = 8000) {
    QTimer::singleShot(ms, p, [p] {
        if (p->state() != QProcess::NotRunning)
            p->kill();
    });
}
}

GpuTelemetry::GpuTelemetry(QObject *parent) : QObject(parent) {
    detectVendor();
    connect(&m_timer, &QTimer::timeout, this, &GpuTelemetry::poll);
    m_timer.setInterval(2000);
    m_timer.start();
    poll(); // sinkron-cepat saja (sysfs); nvidia menendang async
}

void GpuTelemetry::detectVendor() {
    // VMware SVGA: vendor 0x15ad (dahulu dibaca via sysfs PCI)
    QString all;
    QDir drm(QStringLiteral("/sys/class/drm"));
    const QStringList cards = drm.entryList(QStringList() << QStringLiteral("card*"),
                                            QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString &e : cards) {
        QFile v(QStringLiteral("/sys/class/drm/") + e + QStringLiteral("/device/vendor"));
        if (v.open(QIODevice::ReadOnly)) { all += QString::fromLatin1(v.readAll()); v.close(); }
    }
    if (all.contains(QStringLiteral("0x15ad"), Qt::CaseInsensitive)) {
        m_vendor = QStringLiteral("vmware");
        m_name = QStringLiteral("VMware SVGA 3D");
        m_vramTotal = 1024;
        return;
    }
    if (all.contains(QStringLiteral("0x10de"), Qt::CaseInsensitive)) {
        m_vendor = QStringLiteral("nvidia");
        m_name = QStringLiteral("NVIDIA GPU");
        return;
    }
    if (all.contains(QStringLiteral("0x1002"), Qt::CaseInsensitive)) {
        m_vendor = QStringLiteral("amd");
        m_name = QStringLiteral("AMD Radeon");
        return;
    }
    m_vendor = QStringLiteral("generic");
    m_name = QStringLiteral("Generic GPU");
}

void GpuTelemetry::poll() {
    pollSysfs();
    kickNvidia();
    emit updated();
}

bool GpuTelemetry::pollSysfs() {
    // Coba sysfs AMD (gagal cepat bila berkas tidak ada).
    for (const QString &c : QStringList({QStringLiteral("card0"), QStringLiteral("card1")})) {
        const QString base = QStringLiteral("/sys/class/drm/") + c + QStringLiteral("/device/");
        QFile busy(base + QStringLiteral("gpu_busy_percent"));
        if (!busy.open(QIODevice::ReadOnly))
            continue;
        const double load = busy.readAll().trimmed().toDouble();
        busy.close();
        m_load = qBound(0.0, load, 100.0);
        QDir hwmon(base + QStringLiteral("hwmon"));
        const QStringList hwmons = hwmon.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
        for (const QString &h : hwmons) {
            QFile t(base + QStringLiteral("hwmon/") + h + QStringLiteral("/temp1_input"));
            if (t.open(QIODevice::ReadOnly)) {
                m_temp = t.readAll().trimmed().toDouble() / 1000.0;
                t.close();
                break;
            }
        }
        QFile vram(base + QStringLiteral("mem_info_vram_used"));
        QFile vramTot(base + QStringLiteral("mem_info_vram_total"));
        if (vram.open(QIODevice::ReadOnly)) {
            m_vramUsed = vram.readAll().trimmed().toDouble() / (1024.0 * 1024.0);
            vram.close();
        }
        if (vramTot.open(QIODevice::ReadOnly)) {
            m_vramTotal = vramTot.readAll().trimmed().toDouble() / (1024.0 * 1024.0);
            vramTot.close();
        }
        return true;
    }
    if (m_vendor == QStringLiteral("vmware")) {
        // Beban emulasi dari CPU agar HUD tidak pernah kosong/throw.
        QFile f(QStringLiteral("/proc/loadavg"));
        if (f.open(QIODevice::ReadOnly)) {
            const double l = f.readAll().split(' ').value(0).toDouble() * 20.0;
            f.close();
            m_load = qBound(0.0, l, 100.0);
            m_temp = 45.0;
            m_vramUsed = m_vramTotal * 0.3;
            return true;
        }
    }
    return false;
}

void GpuTelemetry::kickNvidia() {
    if (m_vendor != QStringLiteral("nvidia"))
        return;
    if (m_nvProc) // query sebelumnya masih jalan → lewati (anti-spike)
        return;
    QProcess *p = new QProcess(this); // parented: auto-hancur, nol leak
    m_nvProc = p;
    connect(p, &QProcess::finished, this, [this, p] {
        // Parse defensif: keluaran rusak → pertahankan nilai terakhir.
        if (p->exitStatus() == QProcess::NormalExit && p->exitCode() == 0) {
            const QString out = QString::fromLocal8Bit(p->readAllStandardOutput())
                                    .trimmed().split(QLatin1Char('\n')).value(0);
            const QStringList parts = out.split(QLatin1Char(','));
            if (parts.size() >= 5) {
                bool ok = false;
                const double l = parts[0].trimmed().toDouble(&ok);
                if (ok) {
                    m_load = l;
                    m_temp = parts[1].trimmed().toDouble();
                    m_vramUsed = parts[2].trimmed().toDouble();
                    m_vramTotal = parts[3].trimmed().toDouble();
                    if (!parts[4].trimmed().isEmpty())
                        m_name = parts[4].trimmed();
                    emit updated();
                }
            }
        }
        p->deleteLater();
        if (m_nvProc == p)
            m_nvProc = nullptr;
    });
    armWatchdog(p);
    p->start(QStringLiteral("nvidia-smi"),
             {QStringLiteral("--query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,name"),
              QStringLiteral("--format=csv,noheader,nounits")});
}
