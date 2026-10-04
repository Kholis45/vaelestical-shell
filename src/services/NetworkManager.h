#pragma once
#include <QObject>
#include <QTimer>
#include <QtDBus/QtDBus>

class QProcess;

// AUDIT TAHAP 3: query nmcli/bluetoothctl ASYNC via QProcess::finished +
// watchdog; tidak ada waitForFinished() di thread UI. Seluruh parse
// defensif (baris rusak/SSID ber-kolon dilewati, tidak pernah crash).
class NetworkManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool wifiEnabled READ wifiEnabled NOTIFY updated)
    Q_PROPERTY(QString ssid READ ssid NOTIFY updated)
    Q_PROPERTY(int signal READ signal NOTIFY updated)
    Q_PROPERTY(QStringList networks READ networks NOTIFY updated)
public:
    explicit NetworkManager(QObject *parent = nullptr);
    bool wifiEnabled() const { return m_wifi; }
    QString ssid() const { return m_ssid; }
    int signal() const { return m_signal; }
    QStringList networks() const { return m_nets; }
    Q_INVOKABLE void toggleWifi();
    Q_INVOKABLE void connectTo(const QString &ssid);
    Q_INVOKABLE void rescan();
signals:
    void updated();
private slots:
    void poll();
private:
    bool m_wifi = false; QString m_ssid; int m_signal = 0; QStringList m_nets;
    QTimer m_timer;
    QProcess *m_radioProc = nullptr; // parented → auto-hancur
    QProcess *m_listProc = nullptr;  // parented → auto-hancur
};

class BluetoothService : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool powered READ powered NOTIFY updated)
    Q_PROPERTY(QStringList devices READ devices NOTIFY updated)
public:
    explicit BluetoothService(QObject *parent = nullptr);
    bool powered() const { return m_powered; }
    QStringList devices() const { return m_devices; }
    Q_INVOKABLE void togglePower();
    Q_INVOKABLE void connectDevice(const QString &addr);
signals:
    void updated();
private slots:
    void poll();
private:
    bool m_powered = false; QStringList m_devices;
    QTimer m_timer;
    QProcess *m_showProc = nullptr; // parented → auto-hancur
    QProcess *m_devProc = nullptr;  // parented → auto-hancur
};
