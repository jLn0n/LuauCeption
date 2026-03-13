#!/bin/bash
BUILDER_SCRIPT="$(realpath "./src/builder")"
MAIN_DIR="$(realpath "./")" # assuming that the script is ran on LuauCeption/ directory

if ! which spider-cli > /dev/null 2>&1; then
    echo "Please install Spider. More info at the project's README."
    exit
fi

mkdir build
cd build
emcmake cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build . --target Luau.LuauCeption.Compiler Luau.LuauCeption.VM Luau.LuauCeption.Full --config RelWithDebInfo -j 2

cd "$MAIN_DIR" 
lune run "$BUILDER_SCRIPT"
