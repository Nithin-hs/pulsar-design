# pulsar-design

Engineering design for the Pulsar device: high-level design (HLD) and low-level design (LLD).

Part of the `pulsar-firmware` parent repo (submodule `design/`).

- `hld/`       system overview, architecture, requirements trace, interfaces
- `lld/`       per-module design: display (TouchGFX), gyro, button, logging, USB CDC, RTOS tasks, memory map
- `diagrams/`  diagram sources (Mermaid or draw.io) and exports

Files are created when the matching work starts. A change that alters the design (task layout,
protocol, memory use) updates the matching document in the same set of commits.
Requirements: Confluence page "Major features and system requirements" (PULSAR space).
