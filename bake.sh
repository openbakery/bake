#!/bin/sh

WORKING_DIRECTORY=./build/bake/cli
BAKE_CLI=$WORKING_DIRECTORY/bakeCLI
BRANCH=develop

bootstrap() {
	if [ -d "$WORKING_DIRECTORY" ]; then
		rm -rf "$WORKING_DIRECTORY"
	fi

	mkdir -p $WORKING_DIRECTORY
	SOURCE_DIRECTORY=$WORKING_DIRECTORY/checkout
	git clone -b $BRANCH https://github.com/openbakery/bake.git $SOURCE_DIRECTORY

	swift build -c release --package-path $SOURCE_DIRECTORY

	mv $SOURCE_DIRECTORY/.build/arm64-apple-macosx/release/bakeCLI $WORKING_DIRECTORY
}

parameters=()

for parameter in "$@"; do
    if [ "$parameter" != "--refresh" ]; then
        parameters+=("$parameter")
		else
		rm -rf "$WORKING_DIRECTORY"
    fi
done


# if [ $# -ge 1 ]; then
# 	if [ $1 = "--clean" ]; then
# 		rm -rf "$WORKING_DIRECTORY"
# 	fi
# fi

if [ ! -f "$BAKE_CLI" ]; then
	bootstrap
fi

$BAKE_CLI "${parameters[@]}"
