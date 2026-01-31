//
// Created by René Pirringer on 8.8.2025
//
import Bake

public struct Xcodebuild {

	public init(
		path: XcodeBuildPaths,
		xcode: XcodeEnvironment,
		scheme: String,
		configuration: String = "Debug",
		sdkType: SDKType,
		codesigning: Codesigning = .automatic,
		architecture: Architecture = .arm64,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters = DefaultParameters(),
		testParameters: TestParameters = TestParameters(),
	) {
		self.path = path
		self.xcode = xcode
		self.configuration = configuration
		self.scheme = scheme
		self.sdkType = sdkType
		self.destination = Self.defaultDestination(sdkType: sdkType)
		self.codesigning = codesigning
		self.architecture = architecture
		self.onlyTest = onlyTest
		self.defaultParameters = defaultParameters
		self.testParameters = testParameters
	}

	public init(
		path: XcodeBuildPaths,
		xcode: XcodeEnvironment,
		scheme: String,
		configuration: String = "Debug",
		destination: Destination,
		codesigning: Codesigning = .automatic,
		architecture: Architecture = .arm64,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters = DefaultParameters(),
		testParameters: TestParameters = TestParameters(),
	) {
		self.init(
			path: path,
			xcode: xcode,
			scheme: scheme,
			configuration: configuration,
			destination: destination,
			codesigning: codesigning,
			architecture: architecture,
			onlyTest: onlyTest,
			defaultParameters: defaultParameters,
			testParameters: testParameters)
	}


	static func defaultDestination(sdkType: SDKType) -> Destination? {
		if sdkType == .macOS {
			return nil
		}
		return sdkType.genericDestination
	}

	let path: XcodeBuildPaths
	let xcode: XcodeEnvironment
	let scheme: String
	let configuration: String
	let sdkType: SDKType
	let destination: Destination?
	let codesigning: Codesigning
	let onlyTest: [String]?
	let defaultParameters: DefaultParameters
	let testParameters: TestParameters
	var commandRunner: CommandRunner { xcode.commandRunner }

	let architecture: Architecture


	public enum Command: String {
		case build
		case buildForTest = "build-for-testing"
		case test
	}


	public func execute(command: Command) async throws {
		let xcodebuildCommand = "/usr/bin/xcodebuild"
		let arguments = self.arguments(command: command)
		try await commandRunner.run(xcodebuildCommand, arguments: arguments)
	}

	func arguments(command: Command) -> [String] {
		var parameters = [
			command.rawValue,
			"-scheme", self.scheme,
			"-configuration", "Debug",
			"-UseNewBuildSystem=YES",
			"DSTROOT=\(path.destinationDirectory.path)",
			"OBJROOT=\(path.objectDirectory.path)",
			"SYMROOT=\(path.symbolDirectory.path)",
			"SHARED_PRECOMPS_DIR=\(path.sharedPrecompiledHeadersDirectory.path)"
		]

		if let destination {
			parameters.append("-destination")
			parameters.append(destination.value)
		} else {
			parameters.append("-arch")
			parameters.append(architecture.value)
		}

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
		if let destination {
			return Xcodebuild(
				path: path,
				xcode: xcode,
				scheme: scheme ?? self.scheme,
				configuration: configuration ?? self.configuration,
				destination: destination,
				codesigning: codesigning ?? self.codesigning,
				architecture: self.architecture,
				onlyTest: onlyTest ?? self.onlyTest,
				defaultParameters: defaultParameters ?? self.defaultParameters,
				testParameters: self.testParameters)
		}
		return Xcodebuild(
			path: path,
			xcode: xcode,
			scheme: scheme ?? self.scheme,
			configuration: configuration ?? self.configuration,
			sdkType: sdkType ?? self.sdkType,
			codesigning: codesigning ?? self.codesigning,
			architecture: self.architecture,
			onlyTest: onlyTest ?? self.onlyTest,
			defaultParameters: defaultParameters ?? self.defaultParameters,
			testParameters: self.testParameters)
	}

}
