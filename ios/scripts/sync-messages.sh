#!/bin/sh
# Copies the website's translation catalogs into the app, so the app says everything in the
# website's exact words. Run before `xcodegen generate` (CI does; so should you, on a Mac).
set -e
cd "$(dirname "$0")/.."
mkdir -p Reps/Resources/Messages
cp ../src/messages/en.json Reps/Resources/Messages/messages-en.json
cp ../src/messages/es.json Reps/Resources/Messages/messages-es.json
echo "Synced $(ls Reps/Resources/Messages | wc -l | tr -d ' ') message catalogs."
