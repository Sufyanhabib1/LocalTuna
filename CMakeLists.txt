cmake_minimum_required(VERSION 3.16)

project(localtuna VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Quick
    QuickControls2
    Multimedia
)

qt_standard_project_setup(REQUIRES 6.8)
qt_add_resources(RESOURCES resources.qrc)
qt_add_executable(applocaltuna
    main.cpp
    ${RESOURCES}
)

qt_add_qml_module(applocaltuna
    URI localtuna
    VERSION 1.0
    QML_FILES Main.qml
    SOURCES
        backend/musicmanager.h
        backend/musicmanager.cpp
        backend/song.h
        backend/node.h
        backend/playlist.h
        backend/playlist.cpp
        backend/searchindex.h
        backend/searchindex.cpp
        backend/bst.h
        backend/bst.cpp
        backend/graph.h
        backend/graph.cpp
        backend/queue.h
        backend/queue.cpp
)

target_link_libraries(applocaltuna
    PRIVATE Qt6::Quick
    Qt6::QuickControls2
    Qt6::Multimedia
)
qt_add_resources(RESOURCES resources.qrc)
