#!/bin/sh

TARGET=release

swift package clean
swift build -c $TARGET

LIBRARY_PATH=`swift build -c $TARGET --show-bin-path`
LIBRARY_NAME=libBake.dylib

swiftc bake.swift -L $LIBRARY_PATH -I $LIBRARY_PATH -lbake

install_name_tool -change @rpath/$LIBRARY_NAME $LIBRARY_PATH/$LIBRARY_NAME bake

rm $LIBRARY_NAME
rm -rf $LIBRARY_NAME.dSYM
