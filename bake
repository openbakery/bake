#!/bin/bash

WORKING_DIRECTORY=./build/bake
BAKE_BOOTSTRAP_DIRECTORY=$WORKING_DIRECTORY/cli
BAKE_BOOTSTRAP_CLI=$BAKE_BOOTSTRAP_DIRECTORY/BakeCLI
BAKE_CLI=$WORKING_DIRECTORY/bootstrap/bake
BRANCH=develop

progress() {
	echo -ne "$1\033[0K\r"
}

bootstrap() {
	progress "Bootstrap"
	if [ -d "$WORKING_DIRECTORY" ]; then
		rm -rf "$WORKING_DIRECTORY"
	fi

	mkdir -p $BAKE_BOOTSTRAP_DIRECTORY
	SOURCE_DIRECTORY=$BAKE_BOOTSTRAP_DIRECTORY/checkout
	progress "Clone"
	git clone --quiet -b $BRANCH https://github.com/openbakery/bake.git $SOURCE_DIRECTORY

	progress "Build"
	swift build --quiet -c release --package-path $SOURCE_DIRECTORY

	mv $SOURCE_DIRECTORY/.build/arm64-apple-macosx/release/BakeCLI $BAKE_BOOTSTRAP_CLI

	progress "Bootstrap"
	$BAKE_BOOTSTRAP_CLI bootstrap > /dev/null
}

parameters=()

for parameter in "$@"; do
    if [ "$parameter" != "--refresh" ]; then
        parameters+=("$parameter")
		else
		rm -rf "$WORKING_DIRECTORY"
    fi
done

if [ ! -f "$BAKE_CLI" ]; then
	bootstrap
elif [ ! -f "$BAKE_BOOTSTRAP_CLI" ]; then
	bootstrap
fi


$BAKE_CLI "${parameters[@]}"

