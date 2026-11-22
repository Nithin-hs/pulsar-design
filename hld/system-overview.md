# System overview {#hld_system_overview}

## Purpose
Pulsar is a handheld device that shows its on-board gyroscope data live and streams it to a PC.

- **On the device:** a startup image, then a menu operated with the single user button B1. One menu entry is
  the **Live Data** screen with numbers and a scrolling graph. Other entries (Device info, Settings) come later.
- **Over USB:** the same data goes to a **PC tool** that shows a live plot, logs to CSV and sends commands.
- **Hardware:** STM32F429I-DISC1 (STM32F429ZIT6, Cortex-M4F, 2.4 inch 240x320 TFT, 8 MB SDRAM, gyroscope, user button, LEDs, USB OTG micro-AB).
- **Software:** C++20 on FreeRTOS, TouchGFX UI, STM32CubeMX HAL.

## Product diagram
The diagram source is `diagrams/product.dot` (exported as `product.svg`).

\dotfile product.dot "Pulsar product block diagram"

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
