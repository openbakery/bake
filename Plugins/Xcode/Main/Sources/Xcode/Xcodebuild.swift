//
// Created by René Pirringer on 8.8.2025
//
import Bake

public struct Xcodebuild: Executable {

	public init(
		command: Command,
		scheme: String,
		configuration: String = "Debug",
		destination: Destination,
		codesigning: Codesigning = .automatic,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters = DefaultParameters(),
		testParameters: TestParameters = TestParameters(),
		xcode: XcodeEnvironment = Xcode(),
		path: XcodeBuildPaths = XcodeBuildPaths(),
	) {
		self.command = command
		self.configuration = configuration
		self.scheme = scheme
		self.destination = destination
		self.codesigning = codesigning
		self.onlyTest = onlyTest
		self.defaultParameters = defaultParameters
		self.testParameters = testParameters
		self.xcode = xcode
		self.path = path
	}


	static func defaultDestination(sdkType: SDKType) -> Destination? {
		if sdkType == .macOS {
			return nil
		}
		return sdkType.genericDestination
	}

	public let command: Command
	public let path: XcodeBuildPaths
	public let xcode: XcodeEnvironment
	public let scheme: String
	public let configuration: String
	public let destination: Destination
	public let codesigning: Codesigning
	public let onlyTest: [String]?
	public let defaultParameters: DefaultParameters
	public let testParameters: TestParameters
	public var sdkType: SDKType { destination.type }
	var commandRunner: CommandRunner { xcode.commandRunner }



	public enum Command: String {
		case build
		case buildForTest = "build-for-testing"
		case test
	}


	public func execute() async throws {
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
		command: Command? = nil,
		scheme: String? = nil,
		configuration: String? = nil,
		destination: Destination? = nil,
		codesigning: Codesigning? = nil,
		onlyTest: [String]? = nil,
		defaultParameters: DefaultParameters? = nil,
		testParameters: TestParameters? = nil
	) -> Xcodebuild {
		return Xcodebuild(
			command: command ?? self.command,
			scheme: scheme ?? self.scheme,
			configuration: configuration ?? self.configuration,
			destination: destination ?? self.destination,
			codesigning: codesigning ?? self.codesigning,
			onlyTest: onlyTest ?? self.onlyTest,
			defaultParameters: defaultParameters ?? self.defaultParameters,
			testParameters: self.testParameters,
			xcode: xcode,
			path: path)
	}

}

extension Job where T == Xcodebuild {

	static func xcodebuild(
		name: String,
		command: Xcodebuild.Command,
		scheme: String,
		configuration: String = "Debug",
		destination: Destination,
		codesigning: Codesigning = .automatic,
		onlyTest: [String]? = nil,
		defaultParameters: Xcodebuild.DefaultParameters = Xcodebuild.DefaultParameters(),
		testParameters: Xcodebuild.TestParameters = Xcodebuild.TestParameters(),
		xcode: XcodeEnvironment = Xcode(),
		path: XcodeBuildPaths = XcodeBuildPaths(),
	) -> Job {
		let executable = Xcodebuild(
			command: .build,
			scheme: scheme,
			configuration: configuration,
			destination: destination,
			codesigning: codesigning,
			onlyTest: onlyTest,
			xcode: xcode,
			path: path)

		return Job(name: name, executable: executable)

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
