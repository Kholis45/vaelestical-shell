#include "StatusNotifierItem.h"
#include <QtDBus/QtDBus>
#include <QTimer>

StatusNotifierTray::StatusNotifierTray(QObject *parent) : QObject(parent) {
    auto *t = new QTimer(this);
    connect(t, &QTimer::timeout, this, &StatusNotifierTray::poll);
    t->setInterval(3000);
    t->start();
    // Own the watcher name so apps register to us
    QDBusConnection::sessionBus().registerService(QStringLiteral("org.kde.StatusNotifierWatcher"));
    poll();
}

void StatusNotifierTray::poll() {
    // AUDIT: asyncCall + watcher → tidak ada blocking .call() di thread UI.
    QDBusInterface watcher(QStringLiteral("org.kde.StatusNotifierWatcher"),
                           QStringLiteral("/StatusNotifierWatcher"),
                           QStringLiteral("org.kde.StatusNotifierWatcher"),
                           QDBusConnection::sessionBus());
    if (!watcher.isValid()) {
        onWatcherFinished(nullptr); // langsung ke fallback lokal
        return;
    }
    QDBusPendingCall call = watcher.asyncCall(QStringLiteral("RegisteredStatusNotifierItems"));
    auto *w = new QDBusPendingCallWatcher(call, this); // parented: nol leak
    connect(w, &QDBusPendingCallWatcher::finished,
            this, &StatusNotifierTray::onWatcherFinished);
}

void StatusNotifierTray::onWatcherFinished(QDBusPendingCallWatcher *watcher) {
    const QScopedPointer<QDBusPendingCallWatcher, QScopedPointerDeleteLater> guard(watcher);
    QStringList found;
    if (watcher) {
        const QDBusPendingReply<QStringList> reply = *watcher;
        if (reply.isValid())
            found = reply.value();
    }
    if (found.isEmpty()) {
        // Fallback sinkron-LOKAL (cepat): enumerasi service terdaftar.
        const QDBusConnection bus = QDBusConnection::sessionBus();
        if (bus.isConnected()) {
            const QStringList svcs = bus.interface()->registeredServiceNames().value();
            for (const QString &s : svcs) {
                if (s.startsWith(QStringLiteral("org.kde.StatusNotifierItem")))
                    found << s;
            }
        }
    }
    if (found != m_items) {
        m_items = found;
        emit updated();
    }
}

void StatusNotifierTray::activate(const QString &id) {
    if (id.isEmpty())
        return;
    QDBusInterface item(id, QStringLiteral("/StatusNotifierItem"),
                        QStringLiteral("org.kde.StatusNotifierItem"));
    if (item.isValid())
        item.asyncCall(QStringLiteral("Activate"), 0, 0);
}

void StatusNotifierTray::refresh() { poll(); }
