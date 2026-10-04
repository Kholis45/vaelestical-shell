#include "PipeWireService.h"
#include <QProcess>
#include <QTimer>
#include <QRegularExpression>

namespace {
void armWatchdog(QProcess *p, int ms = 8000) {
    QTimer::singleShot(ms, p, [p] {
        if (p->state() != QProcess::NotRunning)
            p->kill();
    });
}
}

PipeWireService::PipeWireService(QObject *parent) : QObject(parent) {
    connect(&m_timer, &QTimer::timeout, this, &PipeWireService::poll);
    m_timer.setInterval(1500);
    m_timer.start();
    poll(); // async: kembali segera, hasil menyusul via updated()
}

QString PipeWireService::shSafe(const QString &s) {
    // Buang karakter quoting/subshell agar nama perangkat tak bisa injeksi.
    QString o = s;
    o.remove(QRegularExpression(QStringLiteral("[\"'\\\\$`(){}!|;&<>]")));
    return o.trimmed();
}

void PipeWireService::poll() {
    if (!m_volProc) {
        QProcess *p = new QProcess(this);
        m_volProc = p;
        connect(p, &QProcess::finished, this, [this, p] {
            if (p->exitStatus() == QProcess::NormalExit && p->exitCode() == 0) {
                const QString v = QString::fromLocal8Bit(p->readAllStandardOutput()).trimmed();
                // "Volume: 0.50 [MUTED]" / "Volume: 0.50"
                if (!v.isEmpty()) {
                    const QStringList parts = v.split(QLatin1Char(' '));
                    if (parts.size() >= 2) {
                        bool ok = false;
                        const double vol = parts[1].toDouble(&ok);
                        if (ok)
                            m_vol = qBound(0.0, vol, 1.5);
                    }
                    m_muted = v.contains(QStringLiteral("MUTED"), Qt::CaseInsensitive);
                    emit updated();
                }
            }
            p->deleteLater();
            if (m_volProc == p)
                m_volProc = nullptr;
        });
        armWatchdog(p);
        p->start(QStringLiteral("wpctl"),
                 {QStringLiteral("get-volume"), QStringLiteral("@DEFAULT_AUDIO_SINK@")});
    }
    if (!m_statProc) {
        QProcess *p = new QProcess(this);
        m_statProc = p;
        connect(p, &QProcess::finished, this, [this, p] {
            if (p->exitStatus() == QProcess::NormalExit && p->exitCode() == 0) {
                const QString status = QString::fromLocal8Bit(p->readAllStandardOutput()).trimmed();
                if (!status.isEmpty()) {
                    QStringList sinks;
                    QString sink;
                    bool inAudio = false;
                    const QStringList lines = status.split(QLatin1Char('\n'));
                    for (const QString &line : lines) {
                        if (line.contains(QStringLiteral("Audio"), Qt::CaseInsensitive))
                            inAudio = true;
                        if (!inAudio)
                            continue;
                        if (line.contains(QStringLiteral("Sources")))
                            break;
                        if (line.contains(QStringLiteral("Sinks")))
                            continue;
                        const QString t = line.trimmed();
                        if (t.startsWith(QLatin1Char('*')) || t.contains(QStringLiteral("alsa"))
                            || t.contains(QStringLiteral("bluez"))
                            || t.contains(QStringLiteral("dante"), Qt::CaseInsensitive)) {
                            // AUDIT: .trimmed() yang dulu terbuang kini disimpan.
                            QString name = t;
                            name.remove(QLatin1Char('*')).remove(QLatin1Char('+'));
                            name = name.trimmed();
                            if (!name.isEmpty()) {
                                sinks << name;
                                if (t.startsWith(QLatin1Char('*')))
                                    sink = name;
                            }
                        }
                    }
                    if (!sinks.isEmpty()) {
                        m_sinks = sinks;
                        m_sink = sink.isEmpty() ? sinks.first() : sink;
                        emit updated();
                    }
                }
            }
            p->deleteLater();
            if (m_statProc == p)
                m_statProc = nullptr;
        });
        armWatchdog(p);
        p->start(QStringLiteral("wpctl"), {QStringLiteral("status")});
    }
}

void PipeWireService::setVolume(double v) {
    v = qBound(0.0, v, 1.5);
    QProcess::startDetached(QStringLiteral("wpctl"),
        {QStringLiteral("set-volume"), QStringLiteral("@DEFAULT_AUDIO_SINK@"), QString::number(v)});
    m_vol = v;
    emit updated();
}
void PipeWireService::setSink(const QString &name) {
    const QString safe = shSafe(name.split(QStringLiteral("  (")).value(0));
    if (safe.isEmpty())
        return;
    QProcess::startDetached(QStringLiteral("bash"), {QStringLiteral("-c"),
        QStringLiteral("wpctl set-default \"$(wpctl status | grep -i ")
            + safe + QStringLiteral(" | head -1 | grep -oE '[0-9]+' | head -1)\" 2>/dev/null; true")});
    m_sink = name;
    emit updated();
}
void PipeWireService::toggleMute() {
    QProcess::startDetached(QStringLiteral("wpctl"),
        {QStringLiteral("set-mute"), QStringLiteral("@DEFAULT_AUDIO_SINK@"), QStringLiteral("toggle")});
}
void PipeWireService::setEqPreset(const QString &preset) {
    const QString safe = shSafe(preset);
    if (safe.isEmpty())
        return;
    QProcess::startDetached(QStringLiteral("bash"),
        {QStringLiteral("-c"), QStringLiteral("easyeffects -l '") + safe + QStringLiteral("' 2>/dev/null; true")});
}
