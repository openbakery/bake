//
// Created by René Pirringer on 3.1.2026
//

import ArgumentParser
import Bake
import Foundation

struct BootstrapCommand: ParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "bootstrap",
		abstract: "Bake Bootstrap."
	)

	// @Argument(help: "The location of the Bake.swift configuration file.")
	// var configPath: String = "Bake"

	@Argument(help: "The location of the Bake.swift configuration file.")
	var configPath: String = ""


	enum Kind: String, ExpressibleByArgument, CaseIterable {
		case bootstrap, clean
	}

	@Option(help: "The kind of average to provide.")
	var kind: Kind = .bootstrap


	mutating func run() {
		Log.info("Bootstrap")

		switch kind {
		case .bootstrap:
			bootstrap()
		case .clean:
			clean()
		}

	}

	private func bootstrap() {
		let url = URL(filePath: configPath)
		guard url.fileExists() else {
			Log.info("Config not found: \(url)")
			return
		}
		do {
			let bootstrap = try Bootstrap(config: url)
			try bootstrap.run()
		} catch {
			Log.info("Error: \(error)")
		}

	}

	private func clean() {
	}
}
