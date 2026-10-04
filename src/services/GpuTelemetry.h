#pragma once
#include <QObject>
#include <QTimer>

class QProcess;

// Universal GPU telemetry: NVIDIA / AMD dGPU / AMD iGPU / VMware SVGA fallback.
// AUDIT TAHAP 3: seluruh query eksternal (nvidia-smi) berjalan ASYNC via
// QProcess::finished — tidak ada waitForFinished() di thread UI. Pembacaan
// sysfs/procf bersifat sinkron namun <1ms. Kegagalan selalu menghasilkan
// nilai default terakhir yang valid, tidak pernah throw/blank.
class GpuTelemetry : public QObject {
    Q_OBJECT
    Q_PROPERTY(double gpuLoad READ gpuLoad NOTIFY updated)
    Q_PROPERTY(double gpuTemp READ gpuTemp NOTIFY updated)
    Q_PROPERTY(double vramUsed READ vramUsed NOTIFY updated)
    Q_PROPERTY(double vramTotal READ vramTotal NOTIFY updated)
    Q_PROPERTY(QString gpuName READ gpuName NOTIFY updated)
    Q_PROPERTY(QString gpuVendor READ gpuVendor NOTIFY updated)
    Q_PROPERTY(int pollInterval READ pollInterval WRITE setPollInterval NOTIFY updated)
public:
    explicit GpuTelemetry(QObject *parent = nullptr);
    double gpuLoad() const { return m_load; }
    double gpuTemp() const { return m_temp; }
    double vramUsed() const { return m_vramUsed; }
    double vramTotal() const { return m_vramTotal; }
    QString gpuName() const { return m_name; }
    QString gpuVendor() const { return m_vendor; }
    int pollInterval() const { return m_timer.interval(); }
public slots:
    void setPollInterval(int ms) { m_timer.setInterval(qBound(1000, ms, 5000)); }
signals:
    void updated();
private slots:
    void poll();
private:
    void detectVendor();
    bool pollSysfs();   // sinkron-cepat: sysfs AMD / fallback loadavg VMware
    void kickNvidia();  // async: hasil via finished-handler + updated()
    double m_load = 0, m_temp = 0, m_vramUsed = 0, m_vramTotal = 4096;
    QString m_name = QStringLiteral("Unknown GPU"), m_vendor = QStringLiteral("generic");
    QTimer m_timer;
    QProcess *m_nvProc = nullptr; // parented ke this → auto-hancur, nol leak
};
