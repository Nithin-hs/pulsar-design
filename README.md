# pulsar-design

Engineering design for the Pulsar device, written as a Doxygen project: high-level design (HLD),
low-level design (LLD), module groups and diagrams.

Part of the `pulsar-firmware` parent repo (submodule `design/`).

## Build the documentation
```
cd design
./build-docs.sh      # or: doxygen Doxyfile
```
Open `doxygen-out/html/index.html`. Needs Doxygen 1.9+, Graphviz and PlantUML (Java). Run it inside the parent repo so that
`../app` is found (the code comments are part of the design).

## Contents
| Path | Contents |
|---|---|
| `Doxyfile` | Doxygen configuration |
| `hld/` | main page, system overview, architecture, repo structure, Doxygen guide, module groups |
| `lld/` | one page per module, created when its work starts |

## Diagrams
- Diagrams are PlantUML blocks inside the pages in `hld/` (see `hld/doxygen-guide.md`).


How we write the design: see `hld/doxygen-guide.md`. Requirements are on Confluence (space PULSAR).
