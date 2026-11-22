#!/usr/bin/env bash
# Generate the design documentation (HTML) into doxygen-out/html.
# Run inside the parent repo so that ../app is found. Needs doxygen and graphviz.
set -e
cd "$(dirname "$0")"
doxygen Doxyfile
echo "Open doxygen-out/html/index.html"
