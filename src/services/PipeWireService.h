#pragma once
#include <QObject>
#include <QTimer>

class QProcess;

// PipeWire audio routing. AUDIT TAHAP 3: polling wpctl ASYNC (dua QProcess
// paralel + watchdog 8 detik). Argumen nama sink/preset disanitasi sebelum
// masuk `sh -c` agar kebal injeksi quoting dari nama perangkat.
class PipeWireService : public QObject {
    Q_OBJECT
    Q_PROPERTY(double volume READ volume WRITE setVolume NOTIFY updated)
    Q_PROPERTY(bool muted READ muted NOTIFY updated)
    Q_PROPERTY(QString sink READ sink NOTIFY updated)
    Q_PROPERTY(QStringList sinks READ sinks NOTIFY updated)
    Q_PROPERTY(double danteLatency READ danteLatency NOTIFY updated)
    Q_PROPERTY(double danteLoss READ danteLoss NOTIFY updated)
public:
    explicit PipeWireService(QObject *parent = nullptr);
    double volume() const { return m_vol; }
    bool muted() const { return m_muted; }
    QString sink() const { return m_sink; }
    QStringList sinks() const { return m_sinks; }
    double danteLatency() const { return m_danteMs; }
    double danteLoss() const { return m_danteLoss; }
    Q_INVOKABLE void setVolume(double v);
    Q_INVOKABLE void setSink(const QString &name);
    Q_INVOKABLE void toggleMute();
    Q_INVOKABLE void setEqPreset(const QString &preset);
signals:
    void updated();
private slots:
    void poll();
private:
    static QString shSafe(const QString &s);
    double m_vol = 0.5; bool m_muted = false;
    QString m_sink; QStringList m_sinks;
    double m_danteMs = 0, m_danteLoss = 0;
    QTimer m_timer;
    QProcess *m_volProc = nullptr;  // parented → auto-hancur
    QProcess *m_statProc = nullptr; // parented → auto-hancur
};
