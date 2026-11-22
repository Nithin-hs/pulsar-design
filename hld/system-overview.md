# System overview {#hld_system_overview}

## Purpose
Pulsar is a handheld device that shows its on-board gyroscope data live and streams it to a PC.

- **On the device:** a startup image, then a menu operated with the single user button B1. One menu entry is
  the **Live Data** screen with numbers and a scrolling graph. Other entries (Device info, Settings) come later.
- **Over USB:** the same data goes to a **PC tool** that shows a live plot, logs to CSV and sends commands.
- **Hardware:** STM32F429I-DISC1 (STM32F429ZIT6, Cortex-M4F, 2.4 inch 240x320 TFT, 8 MB SDRAM, gyroscope, user button, LEDs, USB OTG micro-AB).
- **Software:** C++20 on FreeRTOS, TouchGFX UI, STM32CubeMX HAL.

## Product diagram
@startuml{product} "Pulsar product block diagram"
skinparam componentStyle rectangle
skinparam shadowing false
actor User
node "PC" {
  [PC tool\nlive plot, CSV, commands] as pc
}
node "Pulsar device (STM32F429I-DISC1)" {
  package "On-board hardware" {
    [User button B1] as btn
    [2.4in TFT 240x320\n8 MB SDRAM] as lcd
    [Gyroscope] as gyro
    [LEDs] as leds
    [USB OTG] as usb
  }
  package "Firmware (C++20, FreeRTOS)" {
    [HAL and drivers\n(CubeMX)] as hal
    [Button input] as input
    [Sensor service] as sensor
    [Display UI\n(TouchGFX)] as ui
    [USB CDC and protocol] as comm
    [Application core] as app
    [Logging] as log
  }
}
User --> btn : presses
lcd --> User : shows
pc <--> usb : USB cable
btn --> hal : GPIO
gyro --> hal : SPI5
lcd <-- hal : LTDC, FMC
leds <-- hal : GPIO
usb <--> hal : USB OTG
hal --> input
hal --> sensor
hal <--> ui
hal <--> comm
input --> app
sensor --> app
app --> ui
app <--> comm
app ..> log
sensor ..> log
comm ..> log
@enduml

## Operating flow
1. Power on: the startup image is shown.
2. Menu: a short press moves to the next entry, a long press selects it.
3. Live Data: shows the gyroscope values as numbers and as a scrolling graph. A long press returns to the menu.
4. In parallel, when a PC is connected, the sensor stream goes over USB and commands from the PC are handled.

Screen layouts and the navigation map are designed in Figma (repo `pulsar-ui-ux`).

## Main interfaces
| Interface | Between | Notes |
|---|---|---|
| Button B1 (PA0) | user and @ref grp_input | short and long press |
| LTDC and FMC SDRAM | @ref grp_display and the TFT | frame buffer in SDRAM |
| SPI5 | @ref grp_sensor and the gyroscope | sample rate to be fixed |
| USB OTG (CDC) | @ref grp_usb and the PC tool | stream out, commands in |
| UART or ITM | @ref grp_logging and a PC terminal | first log sink |

## Out of scope for the prototype
Touch input, wireless, a custom board and enclosure, and production tests. They are listed on the roadmap.
