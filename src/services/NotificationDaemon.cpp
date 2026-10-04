#include "NotificationDaemon.h"

NotificationDaemon::NotificationDaemon(QObject *parent) : QObject(parent) {
    // AUDIT: bila bus sesi tak ada / nama sudah dimiliki daemon lain,
    // registrasi gagal anggun — Notify tetap aman dipanggil (no-op
    // efektif) dan toast QML punya jalur demo sendiri. Tanpa crash.
    const QDBusConnection bus = QDBusConnection::sessionBus();
    if (!bus.isConnected())
        return;
    bus.registerService(QStringLiteral("org.freedesktop.Notifications"));
    bus.registerObject(QStringLiteral("/org/freedesktop/Notifications"), this,
        QDBusConnection::ExportAllSlots | QDBusConnection::ExportAllSignals);
}

uint NotificationDaemon::Notify(const QString &app, uint replaces, const QString &icon,
    const QString &summary, const QString &body, const QStringList &,
    const QVariantMap &, int) {
    uint id = replaces ? replaces : m_next++;
    if (!m_dnd) emit notification(id, app, summary, body, icon);
    return id;
}
void NotificationDaemon::CloseNotification(uint id) { emit closed(id); }
QStringList NotificationDaemon::GetCapabilities() {
    return {"body", "icon-static", "actions", "persistence"};
}
QString NotificationDaemon::GetServerInformation(QString &vendor, QString &version, QString &spec) {
    vendor = "vxvicfg"; version = "2.0"; spec = "1.2";
    return "vxvicfg";
}
void NotificationDaemon::dismiss(int id) { emit closed((uint)id); }
