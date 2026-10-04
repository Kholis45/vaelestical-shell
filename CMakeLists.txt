cmake_minimum_required(VERSION 3.19)
project(vxvicfg_core VERSION 2.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core DBus Qml Quick Concurrent)
find_package(PkgConfig QUIET)

if(PKG_CONFIG_FOUND)
  pkg_check_modules(PIPEWIRE QUIET libpipewire-0.3)
  pkg_check_modules(NVML QUIET nvidia-ml)
endif()

# PAM is optional (needed only for lockscreen auth)
find_path(PAM_INCLUDE security/pam_appl.h pam_appl.h)
find_library(PAM_LIB pam)

add_library(vxvicfg_core SHARED
  src/main.cpp
  src/services/GpuTelemetry.cpp
  src/services/PipeWireService.cpp
  src/services/NetworkManager.cpp
  src/services/BluetoothService.cpp
  src/services/StatusNotifierItem.cpp
  src/services/NotificationDaemon.cpp
  src/engine/MatugenEngine.cpp
  src/engine/PamAuth.cpp
)

target_include_directories(vxvicfg_core PRIVATE src src/services src/engine ${PIPEWIRE_INCLUDE_DIRS})
target_link_libraries(vxvicfg_core PRIVATE
  Qt6::Core Qt6::DBus Qt6::Qml Qt6::Quick Qt6::Concurrent
)
if(PIPEWIRE_FOUND)
  target_compile_definitions(vxvicfg_core PRIVATE HAS_PIPEWIRE=1)
  target_link_libraries(vxvicfg_core PRIVATE ${PIPEWIRE_LIBRARIES})
endif()
if(PAM_INCLUDE AND PAM_LIB)
  target_compile_definitions(vxvicfg_core PRIVATE HAS_PAM=1)
  target_include_directories(vxvicfg_core PRIVATE ${PAM_INCLUDE})
  target_link_libraries(vxvicfg_core PRIVATE ${PAM_LIB})
endif()

target_compile_options(vxvicfg_core PRIVATE -O2 -Wall -Wextra -fPIC)

# QML module install path for Quickshell
include(GNUInstallDirs)
set(VAEL_QMLDIR "${CMAKE_INSTALL_LIBDIR}/qt6/qml/vxvicfg/Core")
install(TARGETS vxvicfg_core LIBRARY DESTINATION "${VAEL_QMLDIR}")
install(FILES src/qmldir DESTINATION "${VAEL_QMLDIR}")
install(DIRECTORY modules/ DESTINATION share/quickshell/modules/vxvicfg)
install(FILES shell.qml DESTINATION share/quickshell/modules/vxvicfg)
install(DIRECTORY config/ DESTINATION share/quickshell/modules/vxvicfg/config)
