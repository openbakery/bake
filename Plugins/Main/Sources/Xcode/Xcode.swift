//
// Created by René Pirringer on 29.10.2025
//
import Bake

public struct Xcode {

	public init(commandRunner: CommandRunner = CommandRunner()) {
		self.commandRunner = commandRunner
	}

	public init(version: Version, commandRunner: CommandRunner = CommandRunner()) async throws {

		let installedXcodes = try await Self.installedXcodes(commandRunner: commandRunner)

		self.init(commandRunner: commandRunner)
	}

	let commandRunner: CommandRunner


	static func installedXcodes(commandRunner: CommandRunner) async throws -> [String] {
		let result = try await commandRunner.runWithResult("/usr/bin/mdfind", "kMDItemCFBundleIdentifier=com.apple.dt.Xcode")
		return result
	}
}
