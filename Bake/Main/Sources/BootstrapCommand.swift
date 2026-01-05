//
// Created by René Pirringer on 3.1.2026
//

import ArgumentParser
import Bake
import Foundation

struct BootstrapCommand: AsyncParsableCommand {
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

	@OptionGroup var options: Options


	mutating func run() async throws {
		let debug = options.debug
		Task { @MainActor in
			if debug {
				Log.level = .debug
			}
		}
		Log.info("Bootstrap")

		switch kind {
		case .bootstrap:
			try await bootstrap()
		case .clean:
			clean()
		}

	}

	private func bootstrap() async throws {
		let url = URL(filePath: configPath)
		guard url.fileExists() else {
			Log.info("Config not found: \(url)")
			return
		}
		do {
			Log.debug("Using configuration: \(url)")
			let bootstrap = try Bootstrap(config: url, commandRunner: CommandRunner())
			try await bootstrap.run()
		} catch {
			Log.info("Error: \(error)")
		}

	}

	private func clean() {
	}
}
