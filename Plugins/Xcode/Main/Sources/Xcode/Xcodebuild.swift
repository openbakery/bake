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
	let commandRunner: CommandRunner
	let defaultParameters: DefaultParameters
	let testParameters: TestParameters

	let architecture: Architecture


	public enum Command: String {
		case build
		// case buildForTest = "build-for-testing"
		case test
	}


	public func execute(command: Command) async throws {
		let xcodebuildCommand = "/usr/bin/xcodebuild"
		var arguments = self.arguments(command: command)  //, destination: destination, codesignIdentity: codesignIdentity, onlyTesting: onlyTesting)
		try await commandRunner.run(xcodebuildCommand, arguments: arguments, environment: [:])
	}

	func arguments(command: Command, /* codesignIdentity: String? = nil, onlyTesting: String? = nil */ ) -> [String] {
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
		parameters += testParameters.parameters

		parameters += codesigning.parameters

		// if let codesignIdentity {
		// 	// 	if codesignIdentity == "" {
		// 	// 		parameters.append(contentsOf: [
		// 	// 			"CODE_SIGN_IDENTITY=",
		// 	// 			"CODE_SIGNING_REQUIRED=NO",
		// 	// 			"CODE_SIGNING_ALLOWED=NO"
		// 	// 		])
		// 	// 	} else {
		// 	parameters.append("CODE_SIGN_IDENTITY=\(codesignIdentity)")
		// 	// 	}
		// } else {
		// 	parameters.append(contentsOf: ["-allowProvisioningUpdates"])
		//
		// }
		//
		// if let onlyTesting {
		// 	parameters.append(contentsOf: ["-only-testing:\(scheme)/\(onlyTesting)"])
		//
		// }

		return parameters
	}

}
