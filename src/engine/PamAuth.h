#pragma once
#include <QObject>

// PAM authentication wrapper. Uses real libpam when HAS_PAM, else
// password-less fallback (returns true) so shell still runs in VMs/tests.
class PamAuth : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool busy READ busy NOTIFY statusChanged)
public:
    explicit PamAuth(QObject *parent = nullptr);
    bool busy() const { return m_busy; }
    Q_INVOKABLE void authenticate(const QString &user, const QString &pass);
signals:
    void succeeded();
    void failed(const QString &message);
    void statusChanged();
private:
    bool m_busy = false;
};
