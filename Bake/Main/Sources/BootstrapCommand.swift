//
// Created by René Pirringer on 3.1.2026
//

import ArgumentParser
import Bake

struct BootstrapCommand: ParsableCommand {
	static let configuration = CommandConfiguration(abstract: "Bake Bootstrap.")

	mutating func run() {
		Log.info("Bootstrap")
	}
}
