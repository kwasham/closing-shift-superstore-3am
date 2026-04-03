#!/usr/bin/env bash
set -euo pipefail
rokit install
stylua src scripts
selene src scripts
