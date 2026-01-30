//
// Created by René Pirringer on 8.8.2025
//
import Bake

public struct Xcodebuild {

	public init(
		path: XcodePath,
		scheme: String,
		configuration: String,
		sdkType: SDKType,
		destination: Destination? = nil,
		codesigning: Codesigning = .automatic,
		architecture: Architecture = .arm64,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters = DefaultParameters(),
		testParameters: TestParameters = TestParameters(),
		commandRunner: CommandRunner
	) {
		self.path = path
		self.configuration = configuration
		self.scheme = scheme
		self.sdkType = sdkType
		self.destination = destination ?? sdkType.genericDestination
		self.codesigning = codesigning
		self.architecture = architecture
		self.onlyTest = onlyTest
		self.defaultParameters = defaultParameters
		self.testParameters = testParameters
		self.commandRunner = commandRunner
	}

	let path: XcodePath
	let scheme: String
	let configuration: String
	let sdkType: SDKType
	let destination: Destination
	let codesigning: Codesigning
	let onlyTest: [String]?
	let commandRunner: CommandRunner
	let defaultParameters: DefaultParameters
	let testParameters: TestParameters

	let architecture: Architecture


	public enum Command: String {
		case build
		case buildForTest = "build-for-testing"
		case test
	}


	public func execute(command: Command) async throws {
		let xcodebuildCommand = "/usr/bin/xcodebuild"
		var arguments = self.arguments(command: command)
		try await commandRunner.run(xcodebuildCommand, arguments: arguments, environment: [:])
	}

	func arguments(command: Command) -> [String] {
		var parameters = [
			command.rawValue,
			"-scheme", self.scheme,
			"-configuration", "Debug",
			"-UseNewBuildSystem=YES",
			"-arch", architecture.value,
			"-destination", destination.value,
			"DSTROOT=\(path.destinationDirectory.path)",
			"OBJROOT=\(path.objectDirectory.path)",
			"SYMROOT=\(path.symbolDirectory.path)",
			"SHARED_PRECOMPS_DIR=\(path.sharedPrecompiledHeadersDirectory.path)"
		]

		parameters += defaultParameters.parameters
		parameters += codesigning.parameters

		if command == .test {
			parameters += testParameters.parameters

			if let onlyTest {
				parameters += onlyTest.map { "-only-testing:\(self.scheme)/\($0)" }
			}
		}

		return parameters
	}

	public func update(
		scheme: String? = nil,
		configuration: String? = nil,
		sdkType: SDKType? = nil,
		destination: Destination? = nil,
		codesigning: Codesigning? = nil,
		architecture: Architecture? = nil,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters? = nil,
		testParameters: TestParameters? = nil
	) -> Xcodebuild {
		Xcodebuild(
			path: path,
			scheme: scheme ?? self.scheme,
			configuration: configuration ?? self.configuration,
			sdkType: sdkType ?? self.sdkType,
			destination: destination ?? self.destination,
			codesigning: codesigning ?? self.codesigning,
			architecture: self.architecture,
			onlyTest: onlyTest ?? self.onlyTest,
			defaultParameters: self.defaultParameters,
			testParameters: self.testParameters,
			commandRunner: self.commandRunner)
	}

}
