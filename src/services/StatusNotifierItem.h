#pragma once
#include <QObject>
#include <QStringList>

class QDBusPendingCallWatcher;

// AUDIT TAHAP 3: RegisteredStatusNotifierItems diambil via asyncCall +
// QDBusPendingCallWatcher (bukan blocking .call() ≤25 dtk di thread UI).
// Bila watcher eksternal tidak ada, fallback enumerasi service lokal
// (cepat, sinkron-lokal) — UI tidak pernah freeze.
class StatusNotifierTray : public QObject {
    Q_OBJECT
    Q_PROPERTY(QStringList items READ items NOTIFY updated)
public:
    explicit StatusNotifierTray(QObject *parent = nullptr);
    QStringList items() const { return m_items; }
    Q_INVOKABLE void activate(const QString &id);
    Q_INVOKABLE void refresh();
signals:
    void updated();
private slots:
    void poll();
    void onWatcherFinished(QDBusPendingCallWatcher *watcher);
private:
    QStringList m_items;
};
