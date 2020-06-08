#!/bin/bash
find "$1" -name "*.es.srt" -exec bash -c 'echo Renaming "$1"; mv "$1" "${1%.es.srt}".srt' - '{}' \;

