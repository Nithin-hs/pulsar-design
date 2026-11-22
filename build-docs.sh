#!/usr/bin/env bash
# Generate the design documentation (HTML) into doxygen-out/html.
# Run inside the parent repo so that ../app is found.
# Needs: doxygen, graphviz, java and plantuml.jar (apt: doxygen graphviz plantuml default-jre-headless).
set -e
cd "$(dirname "$0")"
export PLANTUML_JAR="${PLANTUML_JAR:-/usr/share/plantuml/plantuml.jar}"
doxygen Doxyfile
echo "Open doxygen-out/html/index.html"
