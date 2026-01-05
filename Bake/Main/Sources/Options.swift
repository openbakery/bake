//
// Created by René Pirringer on 5.1.2026
//
import ArgumentParser

struct Options: ParsableArguments {
	@Flag(
		name: [.customLong("debug"), .customShort("d")],
		help: "Enable debug output.")
	var debug = false

}
