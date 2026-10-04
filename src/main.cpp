#include <QtQml/QQmlEngineExtensionPlugin>
#include <QtQml/qqml.h>
#include "services/GpuTelemetry.h"
#include "services/PipeWireService.h"
#include "services/NetworkManager.h"
#include "services/StatusNotifierItem.h"
#include "services/NotificationDaemon.h"
#include "engine/MatugenEngine.h"
#include "engine/PamAuth.h"

// Vxvicfg.Core QML extension plugin.
// Dibangun sebagai libvxvicfg_core.so dan dimuat Quickshell/PySide6 via:
//   import Vxvicfg.Core 1.0
// Seluruh modul QML tetap berjalan TANPA plugin ini (mode demo), sehingga
// shell tidak pernah crash bila .so belum terinstal.
class VxvicfgPlugin : public QQmlEngineExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
public:
    void initializeEngine(QQmlEngine *engine, const char *uri) override {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("Vxvicfg.Core"));
        Q_UNUSED(engine);
        qmlRegisterSingletonType<GpuTelemetry>("Vxvicfg.Core", 1, 0, "Gpu",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new GpuTelemetry(e); });
        qmlRegisterSingletonType<PipeWireService>("Vxvicfg.Core", 1, 0, "Audio",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new PipeWireService(e); });
        qmlRegisterSingletonType<NetworkManager>("Vxvicfg.Core", 1, 0, "Net",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new NetworkManager(e); });
        qmlRegisterSingletonType<BluetoothService>("Vxvicfg.Core", 1, 0, "Bt",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new BluetoothService(e); });
        qmlRegisterSingletonType<StatusNotifierTray>("Vxvicfg.Core", 1, 0, "Tray",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new StatusNotifierTray(e); });
        qmlRegisterSingletonType<NotificationDaemon>("Vxvicfg.Core", 1, 0, "Notifs",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new NotificationDaemon(e); });
        qmlRegisterSingletonType<MatugenEngine>("Vxvicfg.Core", 1, 0, "Matugen",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new MatugenEngine(e); });
        qmlRegisterSingletonType<PamAuth>("Vxvicfg.Core", 1, 0, "Pam",
            [](QQmlEngine *e, QJSEngine *) -> QObject * { return new PamAuth(e); });
    }
};

#include "main.moc"
