#!/bin/sh

TARGET=release
DESTINATION=bakeCLI

swift package clean
swift build -c $TARGET


if [ $? != 0 ]; then
  echo "Build failed"
  exit 1
fi

LIBRARY_BUILD_PATH=`swift build -c $TARGET --show-bin-path`
LIBRARY_NAME=libBake.dylib

LIBRARY_PATH=.build/lib
mkdir $LIBRARY_PATH

cp -r $LIBRARY_BUILD_PATH/*.dylib $LIBRARY_PATH


echo "Compile bake.swift"
echo "LIBRARY_PATH: $LIBRARY_PATH"
# swiftc bake.swift -parse-as-library -L $LIBRARY_PATH -I $LIBRARY_PATH -lbake -o $DESTINATION
echo swiftc bake.swift -L $LIBRARY_PATH -I $LIBRARY_PATH -lBake -o $DESTINATION
swiftc bake.swift -L $LIBRARY_PATH -I $LIBRARY_PATH -lBake -o $DESTINATION

install_name_tool -change @rpath/$LIBRARY_NAME $LIBRARY_PATH/$LIBRARY_NAME $DESTINATION

rm $LIBRARY_NAME
rm -rf $LIBRARY_NAME.dSYM
