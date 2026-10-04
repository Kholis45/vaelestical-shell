#include "MatugenEngine.h"
#include <QImage>
#include <QProcess>
#include <QMap>
#include <QPointer>
#include <QtConcurrent/QtConcurrent>

namespace {
// Murni + thread-safe: tanpa akses member, tanpa I/O.
bool sampleColors(const QString &path, QColor &accentOut, QColor &secondaryOut) {
    QImage img(path);
    if (img.isNull())
        return false;
    img = img.scaled(64, 64, Qt::IgnoreAspectRatio, Qt::FastTransformation);
    QMap<QRgb, int> hist;
    for (int y = 0; y < img.height(); ++y) {
        const QRgb *line = reinterpret_cast<const QRgb*>(img.constScanLine(y));
        for (int x = 0; x < img.width(); ++x) {
            const QRgb px = line[x];
            // quantize ke 4 bit/kanal, lewati mendekati abu-abu
            const int r = qRed(px) & 0xF0, g = qGreen(px) & 0xF0, b = qBlue(px) & 0xF0;
            if (qAbs(r - g) < 16 && qAbs(g - b) < 16)
                continue;
            hist[qRgb(r, g, b)]++;
        }
    }
    QRgb best = 0;
    int bc = 0;
    for (auto it = hist.constBegin(); it != hist.constEnd(); ++it) {
        if (it.value() > bc) {
            bc = it.value();
            best = it.key();
        }
    }
    if (bc <= 0)
        return false;
    QColor c(best);
    accentOut = c.lightness() < 150 ? c.lighter(160) : c;
    secondaryOut = QColor(accentOut).darker(150);
    return true;
}
}

MatugenEngine::MatugenEngine(QObject *parent) : QObject(parent) {}

void MatugenEngine::setWallpaper(const QString &p) {
    if (p == m_wall)
        return;
    m_wall = p;
    const int gen = ++m_gen;
    const QPointer<MatugenEngine> self(this);
    QtConcurrent::run([self, p, gen] {
        QColor accent, secondary;
        const bool ok = sampleColors(p, accent, secondary);
        if (MatugenEngine *o = self.data()) {
            QMetaObject::invokeMethod(o, [o, accent, secondary, ok, gen] {
                if (gen != o->m_gen.load())
                    return; // basi: wallpaper sudah diganti lagi
                if (ok) {
                    o->m_accent = accent;
                    o->m_secondary = secondary;
                }
                emit o->paletteChanged();
            }, Qt::QueuedConnection);
        }
    });
    // Fire-and-forget full matugen scheme (tanpa blokir).
    QProcess::startDetached(QStringLiteral("matugen"),
        {QStringLiteral("image"), p, QStringLiteral("--mode"), QStringLiteral("dark")});
    emit paletteChanged(); // wallpaper berubah segera; warna menyusul
}

void MatugenEngine::applyToTerminals(const QColor &accent) {
    // Tanpa shell interpolation dari input bebas: hanya hex terverifikasi.
    const QString hex = accent.name();
    if (!hex.startsWith(QLatin1Char('#')))
        return;
    QProcess::startDetached(QStringLiteral("bash"), {QStringLiteral("-c"),
        QStringLiteral("mkdir -p ~/.cache/vxvicfg && echo '") + hex
            + QStringLiteral("' > ~/.cache/vxvicfg/accent 2>/dev/null; true")});
}
