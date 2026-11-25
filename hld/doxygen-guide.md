# How we design with Doxygen {#doxygen_guide}

The design is written as Doxygen pages and comments, so the design and the code are documented in one place
and the HTML is generated from the repositories.

## Build the documentation
Inside the parent repo (so that `../app` is found):
```
cd design
./build-docs.sh        # or: doxygen Doxyfile
```
Open `doxygen-out/html/index.html`. Needs Doxygen 1.9 or newer, Graphviz, Java and `plantuml.jar` (apt: `doxygen graphviz plantuml default-jre-headless`; set `PLANTUML_JAR` if the jar is elsewhere). The output folder is not committed.

## Published site
The repo is private, so the HTML is not published automatically. A private copy is published as a
claude.ai page and refreshed from `main` on request. The workflow `.github/workflows/pages.yml` (GitHub Pages,
public site) is manual only and unused.

## What goes where
| What | Where | How |
|---|---|---|
| Overview pages | `hld/*.md` | `# Title {#page_id}` and `@ref page_id` |
| Modules | `hld/modules.dox` | one `@defgroup grp_xxx` per module with its responsibility and epics |
| Module design (LLD) | `lld/<module>.md` | page `{#lld_<module>}`, linked from the group with `@ref` |
| Diagrams | inside the pages | PlantUML: `@startuml{name} "caption"` ... `@enduml` (component, sequence, state, class diagrams) |
| Code documentation | headers in `pulsar-app` | `@file`, `@brief`, `@param`, `@return`, and `@ingroup grp_xxx` |
| Jira link | any comment | `\jira{KAN-12}` |
| Requirement link | any comment | `\req{SR-n}` collects a Requirements list (first use comes with the first requirement mapping) |

## Rules
1. **Design first:** a module gets its `@defgroup` and design notes before its code is written.
2. **Document public items:** every public class, function and type in `app/` has a `@brief` and an `@ingroup`.
   `WARN_IF_UNDOCUMENTED` is on, so missing documentation shows up as a warning.
3. **Update with the code:** a change that alters the design (task layout, protocol, memory use) updates the
   page or the comment in the same set of commits.
4. **Diagrams are text:** PlantUML sits inside the Doxygen pages, so diagrams diff and review like code.
5. **No generated output in git:** `doxygen-out/` is ignored.

## Adding a module
1. Add `@defgroup grp_name Title` in `hld/modules.dox` with the responsibility, dependencies and epics.
2. Write the low-level design page `lld/name.md` when the work starts.
3. In the module headers add `@ingroup grp_name` and the `@brief` text.
4. Build the docs and fix the warnings.
