# Behaviour {#hld_behaviour}

Dynamic design of the device. Everything here is the **proposed** behaviour from the product description
(single button, startup image, menu, Live Data). Timings and priorities are set in the LLD after the
TouchGFX bring-up (@jira{KAN-12}).

## Screen state machine
@startuml{ui_states} "Screens and button events"
skinparam shadowing false
[*] --> Startup
Startup --> Menu : image shown
Menu --> Menu : short press (next entry)
Menu --> LiveData : long press on Live Data
Menu --> DeviceInfo : long press on Device info
Menu --> Settings : long press on Settings
LiveData --> Menu : long press
DeviceInfo --> Menu : long press
Settings --> Menu : long press
@enduml

## Button press to new screen
@startuml{seq_button} "Button event"
skinparam shadowing false
actor User
participant "Button input" as In
participant "Application core" as App
participant "Display UI" as UI
User -> In : press and release
In -> In : debounce, classify short or long
In -> App : ButtonEvent(short|long)
App -> App : menu state update
App -> UI : show(screen)
UI --> User : new screen
@enduml

## Gyroscope sample to screen and PC
@startuml{seq_sample} "Sample flow"
skinparam shadowing false
participant "Sensor service" as S
participant "Application core" as A
participant "Display UI" as UI
participant "USB CDC" as U
participant "PC tool" as PC
loop every sample period
  S -> S : read gyro over SPI5
  S -> A : Sample(x, y, z, t)
  A -> UI : update numbers and graph (Live Data only)
  A -> U : stream(Sample)
  U -> PC : packet
end
PC -> U : command
U -> A : Command
@enduml
