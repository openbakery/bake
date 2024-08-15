#!/bin/sh

TARGET=release
DESTINATION=bakeCLI

swift package clean
swift build -c $TARGET

LIBRARY_PATH=`swift build -c $TARGET --show-bin-path`
LIBRARY_NAME=libBake.dylib

echo "Compile bake.swift"
echo "LIBRARY_PATH: $LIBRARY_PATH"
swiftc bake.swift -L $LIBRARY_PATH -I $LIBRARY_PATH -lbake -o $DESTINATION

install_name_tool -change @rpath/$LIBRARY_NAME $LIBRARY_PATH/$LIBRARY_NAME $DESTINATION

rm $LIBRARY_NAME
rm -rf $LIBRARY_NAME.dSYM
