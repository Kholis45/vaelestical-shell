#pragma once
#include <QObject>
#include <QtDBus/QtDBus>

// Implements org.freedesktop.Notifications server + forwards to QML.
class NotificationDaemon : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool dnd READ dnd WRITE setDnd NOTIFY dndChanged)
public:
    explicit NotificationDaemon(QObject *parent = nullptr);
    bool dnd() const { return m_dnd; }
    void setDnd(bool v) { m_dnd = v; emit dndChanged(); }
    Q_INVOKABLE void dismiss(int id);
signals:
    void notification(uint id, const QString &app, const QString &summary, const QString &body, const QString &icon);
    void closed(uint id);
    void dndChanged();
public slots:
    // DBus API
    uint Notify(const QString &app, uint replaces, const QString &icon,
                const QString &summary, const QString &body,
                const QStringList &actions, const QVariantMap &hints, int timeout);
    void CloseNotification(uint id);
    QStringList GetCapabilities();
    QString GetServerInformation(QString &vendor, QString &version, QString &spec);
private:
    bool m_dnd = false;
    uint m_next = 1;
};
