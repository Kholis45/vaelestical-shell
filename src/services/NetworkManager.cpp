#include "NetworkManager.h"
#include <QProcess>
#include <QTimer>

namespace {
void armWatchdog(QProcess *p, int ms = 8000) {
    QTimer::singleShot(ms, p, [p] {
        if (p->state() != QProcess::NotRunning)
            p->kill();
    });
}
}

NetworkManager::NetworkManager(QObject *parent) : QObject(parent) {
    connect(&m_timer, &QTimer::timeout, this, &NetworkManager::poll);
    m_timer.setInterval(4000);
    m_timer.start();
    poll(); // async: kembali segera
}

void NetworkManager::poll() {
    if (!m_radioProc) {
        QProcess *p = new QProcess(this);
        m_radioProc = p;
        connect(p, &QProcess::finished, this, [this, p] {
            if (p->exitStatus() == QProcess::NormalExit && p->exitCode() == 0) {
                const QString w = QString::fromLocal8Bit(p->readAllStandardOutput()).trimmed();
                if (!w.isEmpty()) {
                    m_wifi = w.contains(QStringLiteral("enabled"), Qt::CaseInsensitive);
                    emit updated();
                }
            }
            p->deleteLater();
            if (m_radioProc == p)
                m_radioProc = nullptr;
        });
        armWatchdog(p);
        p->start(QStringLiteral("nmcli"),
                 {QStringLiteral("-t"), QStringLiteral("-f"), QStringLiteral("WIFI"),
                  QStringLiteral("radio")});
    }
    if (!m_listProc) {
        QProcess *p = new QProcess(this);
        m_listProc = p;
        connect(p, &QProcess::finished, this, [this, p] {
            if (p->exitStatus() == QProcess::NormalExit && p->exitCode() == 0) {
                const QString cur = QString::fromLocal8Bit(p->readAllStandardOutput()).trimmed();
                // nmcli -t memakai ':' sebagai separator; SSID ber-kolon bisa
                // menggeser kolom → parse dari kanan (ACTIVE:SSID:SIGNAL),
                // SIGNAL = segmen terakhir, ACTIVE = segmen pertama.
                QStringList nets;
                QString ssid;
                int signal = 0;
                const QStringList lines = cur.split(QLatin1Char('\n'));
                for (const QString &l : lines) {
                    if (l.isEmpty())
                        continue;
                    const QStringList cols = l.split(QLatin1Char(':'));
                    if (cols.size() < 3)
                        continue; // baris rusak → lewati, jangan crash
                    const QString active = cols.first().trimmed();
                    bool ok = false;
                    const int sig = cols.last().trimmed().toInt(&ok);
                    const QString name = cols.mid(1, cols.size() - 2).join(QLatin1Char(':')).trimmed();
                    if (name.isEmpty())
                        continue;
                    nets << (name + QStringLiteral("  (") + (ok ? QString::number(sig) : QStringLiteral("?")) + QStringLiteral("%)"));
                    if (active.compare(QStringLiteral("yes"), Qt::CaseInsensitive) == 0) {
                        ssid = name;
                        signal = ok ? sig : 0;
                    }
                }
                m_nets = nets;
                m_ssid = ssid;
                m_signal = signal;
                emit updated();
            }
            p->deleteLater();
            if (m_listProc == p)
                m_listProc = nullptr;
        });
        armWatchdog(p, 10000); // scan wifi boleh sedikit lebih lama
        p->start(QStringLiteral("nmcli"),
                 {QStringLiteral("-t"), QStringLiteral("-f"), QStringLiteral("ACTIVE,SSID,SIGNAL"),
                  QStringLiteral("dev"), QStringLiteral("wifi"), QStringLiteral("list"),
                  QStringLiteral("--rescan"), QStringLiteral("no")});
    }
}

void NetworkManager::toggleWifi() {
    QProcess::startDetached(QStringLiteral("nmcli"),
        {QStringLiteral("radio"), QStringLiteral("wifi"), m_wifi ? QStringLiteral("off") : QStringLiteral("on")});
}

void NetworkManager::connectTo(const QString &ssid) {
    // argv langsung (tanpa shell) → kebal injeksi; SSID utuh dipertahankan.
    const QString s = ssid.split(QStringLiteral("  (")).value(0).trimmed();
    if (s.isEmpty())
        return;
    QProcess::startDetached(QStringLiteral("nmcli"),
        {QStringLiteral("dev"), QStringLiteral("wifi"), QStringLiteral("connect"), s});
}

void NetworkManager::rescan() { poll(); }

BluetoothService::BluetoothService(QObject *parent) : QObject(parent) {
    connect(&m_timer, &QTimer::timeout, this, &BluetoothService::poll);
    m_timer.setInterval(4000);
    m_timer.start();
    poll(); // async: kembali segera
}

void BluetoothService::poll() {
    if (!m_showProc) {
        QProcess *p = new QProcess(this);
        m_showProc = p;
        connect(p, &QProcess::finished, this, [this, p] {
            if (p->exitStatus() == QProcess::NormalExit && p->exitCode() == 0) {
                const QString show = QString::fromLocal8Bit(p->readAllStandardOutput());
                m_powered = show.contains(QStringLiteral("Powered: yes"), Qt::CaseSensitive);
                emit updated();
            }
            p->deleteLater();
            if (m_showProc == p)
                m_showProc = nullptr;
        });
        armWatchdog(p);
        // Paksa non-interaktif + timeout agar tidak menggantung di prompt.
        p->start(QStringLiteral("bash"), {QStringLiteral("-c"),
            QStringLiteral("timeout 5 bluetoothctl show 2>/dev/null; true")});
    }
    if (!m_devProc) {
        QProcess *p = new QProcess(this);
        m_devProc = p;
        connect(p, &QProcess::finished, this, [this, p] {
            if (p->exitStatus() == QProcess::NormalExit) {
                const QString devs = QString::fromLocal8Bit(p->readAllStandardOutput()).trimmed();
                QStringList found;
                const QStringList lines = devs.split(QLatin1Char('\n'));
                for (const QString &l : lines) {
                    const QString t = l.trimmed();
                    if (t.startsWith(QStringLiteral("Device")))
                        found << t.mid(6).trimmed();
                }
                m_devices = found;
                emit updated();
            }
            p->deleteLater();
            if (m_devProc == p)
                m_devProc = nullptr;
        });
        armWatchdog(p);
        p->start(QStringLiteral("bash"), {QStringLiteral("-c"),
            QStringLiteral("timeout 5 bluetoothctl devices 2>/dev/null; true")});
    }
}

void BluetoothService::togglePower() {
    QProcess::startDetached(QStringLiteral("bluetoothctl"),
        {QStringLiteral("power"), m_powered ? QStringLiteral("off") : QStringLiteral("on")});
}

void BluetoothService::connectDevice(const QString &addr) {
    // Token pertama = MAC; argv langsung tanpa shell.
    const QString mac = addr.split(QLatin1Char(' ')).value(0).trimmed();
    if (mac.isEmpty())
        return;
    QProcess::startDetached(QStringLiteral("bluetoothctl"), {QStringLiteral("connect"), mac});
}
