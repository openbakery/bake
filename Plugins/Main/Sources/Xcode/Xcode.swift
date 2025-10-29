//
// Created by René Pirringer on 29.10.2025
//
import Bake

public struct Xcode {

	public init(xcodePath: String? = nil, commandRunner: CommandRunner = CommandRunner()) {
		self.commandRunner = commandRunner
		self.xcodePath = xcodePath
	}

	public init?(version: Version, commandRunner: CommandRunner = CommandRunner()) async throws {

		guard let xcodePath = try await Self.findXcode(version: version, commandRunner: commandRunner) else {
			return nil
		}

		self.init(xcodePath: xcodePath, commandRunner: commandRunner)
	}

	let commandRunner: CommandRunner
	let xcodePath: String?


	static func installedXcodes(commandRunner: CommandRunner) async throws -> [String] {
		let result = try await commandRunner.runWithResult("/usr/bin/mdfind", "kMDItemCFBundleIdentifier=com.apple.dt.Xcode")
		return result
	}


	static func findXcode(version: Version, commandRunner: CommandRunner) async throws -> String? {

		let xcodes = try await installedXcodes(commandRunner: commandRunner)

		for xcode in xcodes {
			if let xcodeVersion = try await getVersion(xcodePath: xcode, commandRunner: commandRunner) {
				if xcodeVersion.major == version.major {
					return xcode
				}
			}
		}
		return nil
	}


	static func getVersion(xcodePath: String, commandRunner: CommandRunner) async throws -> Version? {
		let command = xcodePath + "/Contents/Developer/usr/bin/xcodebuild"
		let result = try await commandRunner.runWithResult(command, "-version")

		guard let line = result.first else { return nil }

		let versionString = String(line.dropFirst(6))  // "Xcode "
		return Version(string: versionString)
	}


}
