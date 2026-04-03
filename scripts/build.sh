#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
rokit install
rojo build default.project.json --output build/ClosingShift.rbxlx
