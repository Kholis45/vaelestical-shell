#pragma once
#include <QObject>
#include <QColor>
#include <atomic>

// Samples wallpaper -> Material You palette. Pure Qt (QImage sampling)
// + optional `matugen` subprocess for full scheme generation.
// AUDIT TAHAP 3: decode + sampling gambar berjalan di worker thread
// (QtConcurrent); thread UI tidak pernah diblokir. Generation counter
// memastikan hanya hasil wallpaper TERBARU yang diterapkan (anti-race
// saat pengguna mengganti wallpaper cepat). QPointer guard mencegah
// use-after-free bila engine dihancurkan selagi worker jalan.
class MatugenEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(QColor accent READ accent NOTIFY paletteChanged)
    Q_PROPERTY(QColor secondary READ secondary NOTIFY paletteChanged)
    Q_PROPERTY(QString wallpaper READ wallpaper WRITE setWallpaper NOTIFY paletteChanged)
public:
    explicit MatugenEngine(QObject *parent = nullptr);
    QColor accent() const { return m_accent; }
    QColor secondary() const { return m_secondary; }
    QString wallpaper() const { return m_wall; }
public slots:
    void setWallpaper(const QString &p);
public:
    Q_INVOKABLE void applyToTerminals(const QColor &accent);
signals:
    void paletteChanged();
private:
    QColor m_accent{QStringLiteral("#a8c7fa")}, m_secondary{QStringLiteral("#384661")};
    QString m_wall;
    std::atomic<int> m_gen{0};
};
