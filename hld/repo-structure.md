# Repository and folder structure {#hld_repo_structure}

The firmware is one parent repository with six submodules. Generated code, hand-written code, UI/UX
sources and the design each live in their own repository.

@startuml{repo_structure} "Pulsar repositories and folders"
skinparam shadowing false
skinparam packageStyle rectangle
package "pulsar-firmware (parent)" {
  note as N
    CMakeLists.txt, CMakePresets.json
    cmake/, scripts/, docs/
  end note
  folder "cubemx/\npulsar-cubemx\nCubeMX generated" as cubemx #E3F0E6
  folder "touchgfx/\npulsar-touchgfx\nassets, gui, generated" as tgfx #E3F0E6
  folder "app/\npulsar-app\nour C++" as app #FFF8E1
  folder "pc-tool/\npulsar-pc-tool" as pc #F4EEF8
  folder "ui-ux/\npulsar-ui-ux\nFigma exports" as uiux #F4EEF8
  folder "design/\npulsar-design\nthis Doxygen design" as design #E8EEF4
}
N .. cubemx
cubemx --> app : HAL
tgfx --> app : GUI hooks
uiux --> tgfx : assets
design ..> app : reads comments
note bottom of app : cubemx, touchgfx and app are built into the firmware
@enduml

## Folder tree
```
pulsar-firmware/                parent repo (github.com/Nithin-hs/pulsar-firmware)
  CMakeLists.txt                top-level build, C++20, never generated
  CMakePresets.json             Debug and Release presets
  cmake/gcc-arm-none-eabi.cmake toolchain file (linker script path points into cubemx/)
  scripts/build.sh              configure and build
  docs/                         short notes
  cubemx/       pulsar-cubemx   CubeMX project: .ioc, Core, Drivers, Middlewares, USB_HOST, startup, linker script
  touchgfx/     pulsar-touchgfx TouchGFX project: assets, gui (ours), generated (Designer)
  app/          pulsar-app      our C++: app.hpp, app.cpp, later gyro, button, logging, protocol
  pc-tool/      pulsar-pc-tool  PC tool
  ui-ux/        pulsar-ui-ux    flows, screens, assets, fonts, startup
  design/       pulsar-design   this design: Doxyfile, hld, lld
```

## Rules
- Generated code lives only in `cubemx/` and `touchgfx/generated/`. Never edit it by hand outside USER CODE blocks.
- The build file lives in the parent repo, so no generator can overwrite it.
- Only `cubemx/`, `touchgfx/` and `app/` are built into the firmware.
- Design flows: Figma to `ui-ux/`, then assets into `touchgfx/assets`. This design reads `../app` for the code comments.
- Commit inside a submodule first, push it, then commit and push the submodule bump in the parent.

The full page with rules, build steps and verification is on Confluence: "Repo structure (Pulsar firmware)"
under Technical Readings (space PULSAR).
