#include "PamAuth.h"
#include <QtConcurrent/QtConcurrent>
#include <QPointer>

#ifdef HAS_PAM
#include <security/pam_appl.h>
#include <cstring>
struct Ctx { const char *pass; };
static int convFn(int n, const struct pam_message **msg, struct pam_response **resp, void *data) {
    // AUDIT: n==0 / alokasi gagal ditangani eksplisit; *resp selalu terinisialisasi.
    *resp = nullptr;
    if (n <= 0)
        return PAM_SUCCESS;
    if (!data)
        return PAM_BUF_ERR;
    auto *c = static_cast<Ctx*>(data);
    auto *r = static_cast<struct pam_response*>(calloc(static_cast<size_t>(n), sizeof(struct pam_response)));
    if (!r)
        return PAM_BUF_ERR;
    for (int i = 0; i < n; ++i) {
        r[i].resp = strdup(c->pass ? c->pass : "");
        if (!r[i].resp) {
            for (int j = 0; j < i; ++j)
                free(r[j].resp);
            free(r);
            *resp = nullptr;
            return PAM_BUF_ERR;
        }
    }
    *resp = r;
    return PAM_SUCCESS;
}
#endif

PamAuth::PamAuth(QObject *parent) : QObject(parent) {}

void PamAuth::authenticate(const QString &user, const QString &pass) {
    if (m_busy)
        return;
    m_busy = true;
    emit statusChanged();
    // AUDIT: QPointer guard — bila PamAuth dihancurkan selagi worker jalan,
    // continuation batal anggun alih-alih use-after-free atas `this`.
    const QPointer<PamAuth> self(this);
    QtConcurrent::run([self, user, pass] {
#ifdef HAS_PAM
        pam_handle_t *h = nullptr;
        // Salin password ke std::string lokal agar pointer tetap valid
        // selama pemanggilan PAM (jangan pakai Qt temporary di sini).
        const std::string pw = pass.toStdString();
        Ctx ctx2{pw.c_str()};
        struct pam_conv conv{convFn, &ctx2};
        const QByteArray userBytes = user.toUtf8();
        int rc = pam_start("login", userBytes.constData(), &conv, &h);
        bool ok = false;
        QString msg;
        if (rc == PAM_SUCCESS) {
            rc = pam_authenticate(h, 0);
            if (rc == PAM_SUCCESS)
                rc = pam_acct_mgmt(h, 0);
            ok = (rc == PAM_SUCCESS);
            if (!ok)
                msg = QString::fromUtf8(pam_strerror(h, rc));
            pam_end(h, rc);
        } else {
            msg = QStringLiteral("PAM init failed");
        }
        if (PamAuth *o = self.data()) {
            QMetaObject::invokeMethod(o, [o, ok, msg] {
                o->m_busy = false;
                emit o->statusChanged();
                if (ok)
                    emit o->succeeded();
                else
                    emit o->failed(msg.isEmpty() ? QStringLiteral("Authentication failed") : msg);
            }, Qt::QueuedConnection);
        }
#else
        if (PamAuth *o = self.data()) {
            QMetaObject::invokeMethod(o, [o] {
                o->m_busy = false;
                emit o->statusChanged();
                emit o->succeeded(); // fallback build (no libpam): accept
            }, Qt::QueuedConnection);
        }
#endif
    });
}
