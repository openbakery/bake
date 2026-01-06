//
// Created by René Pirringer on 5.1.2026
//
import ArgumentParser
import Bake

struct Options: ParsableArguments {
	@Flag(
		name: [.customLong("debug"), .customShort("d")],
		help: "Enable debug output.")
	var debug = false

}


extension AsyncParsableCommand {

	func apply(options: Options) {
		let debug = options.debug
		Task { @MainActor in
			if debug {
				Log.level = .debug
			}
		}
	}
}
