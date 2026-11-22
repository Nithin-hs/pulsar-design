# Architecture {#hld_architecture}

## Layers
| Layer | Modules | Written by |
|---|---|---|
| Application | @ref grp_app | us (`pulsar-app`) |
| Services | @ref grp_sensor, @ref grp_input, @ref grp_usb, @ref grp_logging | us (`pulsar-app`) |
| UI | @ref grp_display | TouchGFX Designer plus us (`pulsar-touchgfx`) |
| Platform | @ref grp_platform | CubeMX (`pulsar-cubemx`) |

Rules:
- A layer calls only the layer below it. The application does not call HAL functions directly.
- Hardware access goes through the platform layer. Services wrap it in small C++ classes.
- Generated code is never edited by hand outside USER CODE blocks.

See the product diagram in @ref hld_system_overview.

## Data flow
- **Gyroscope to screen:** @ref grp_sensor reads samples, @ref grp_app forwards them to @ref grp_display.
- **Gyroscope to PC:** @ref grp_sensor sends the stream to @ref grp_usb.
- **Button to screen:** @ref grp_input sends events to @ref grp_app, which changes the screen.
- **PC to device:** commands arrive in @ref grp_usb and go to @ref grp_app.

## Structure
@startuml{classes} "Planned classes (proposed, names not final)"
skinparam shadowing false
skinparam classAttributeIconSize 0
class App {
  +init()
  +loop()
}
class ButtonInput
class SensorService
class DisplayPresenter
class UsbLink
class Logger
App --> ButtonInput
App --> SensorService
App --> DisplayPresenter
App --> UsbLink
App ..> Logger
SensorService ..> Logger
UsbLink ..> Logger
@enduml

## Tasks (planned, to be confirmed in the LLD)
| Task | Job | Priority |
|---|---|---|
| Default task | runs `app_loop()` today; later the application core | to be set |
| GUI task | TouchGFX tick and drawing | to be set |
| Sensor task | gyroscope sampling at a fixed rate | to be set |
| USB task | CDC transmit and receive | to be set |
| Log task | drains the log buffer | lowest |

@startuml{tasks} "FreeRTOS tasks and queues (proposed)"
skinparam shadowing false
component "Sensor task" as ST
component "App task" as AT
component "GUI task" as GT
component "USB task" as UT
component "Log task" as LT
queue "sample queue" as SQ
queue "event queue" as EQ
queue "tx queue" as TQ
ST --> SQ
SQ --> AT
EQ --> AT
AT --> GT : screen and data
AT --> TQ
TQ --> UT
ST ..> LT
AT ..> LT
UT ..> LT
@enduml

Priorities, stack sizes and queues are decided in the RTOS low-level design after the TouchGFX bring-up
(@jira{KAN-12}).

## Memory (known facts)
- STM32F429ZIT6: 2 MB flash, 256 KB RAM (192 KB main plus 64 KB CCM), 8 MB external SDRAM on the board.
- One RGB565 frame is 153,600 B, so frame buffers belong in the SDRAM.
- Current image (LED blink): flash 53,788 B (2.56%), RAM 38,432 B (19.55%).

## Build and clock
- Top-level CMake in the parent repo, C++20, arm-none-eabi-gcc. See @ref hld_repo_structure.
- System clock is 72 MHz today and must go to 180 MHz (@jira{KAN-3}).
