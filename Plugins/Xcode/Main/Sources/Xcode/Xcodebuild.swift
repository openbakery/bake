//
// Created by René Pirringer on 8.8.2025
//
import Bake

public struct Xcodebuild {

	public init(
		xcode: XcodeEnvironment,
		scheme: String,
		configuration: String = "Debug",
		destination: Destination,
		codesigning: Codesigning = .automatic,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters = DefaultParameters(),
		testParameters: TestParameters = TestParameters(),
		path: XcodeBuildPaths = XcodeBuildPaths(),
	) {
		self.path = path
		self.xcode = xcode
		self.configuration = configuration
		self.scheme = scheme
		self.destination = destination
		self.codesigning = codesigning
		self.onlyTest = onlyTest
		self.defaultParameters = defaultParameters
		self.testParameters = testParameters
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
	let destination: Destination
	let codesigning: Codesigning
	let onlyTest: [String]?
	let defaultParameters: DefaultParameters
	let testParameters: TestParameters
	var sdkType: SDKType { destination.type }
	var commandRunner: CommandRunner { xcode.commandRunner }



	public enum Command: String {
		case build
		case buildForTest = "build-for-testing"
		case test
	}


	public func execute(command: Command) async throws {
		try path.prepare()
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

		parameters += destination.parameters

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
		destination: Destination? = nil,
		codesigning: Codesigning? = nil,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters? = nil,
		testParameters: TestParameters? = nil
	) -> Xcodebuild {
		return Xcodebuild(
			xcode: xcode,
			scheme: scheme ?? self.scheme,
			configuration: configuration ?? self.configuration,
			destination: destination ?? self.destination,
			codesigning: codesigning ?? self.codesigning,
			onlyTest: onlyTest ?? self.onlyTest,
			defaultParameters: defaultParameters ?? self.defaultParameters,
			testParameters: self.testParameters,
			path: path)
	}

}

extension Destination {
	var parameters: [String] {
		var result = [String]()
		if type == .macOS {
			if let architecture {
				result.append("-arch")
				result.append(architecture.value)
				return result
			}
		}
		result.append("-destination")
		result.append(value)
		return result

	}

}
