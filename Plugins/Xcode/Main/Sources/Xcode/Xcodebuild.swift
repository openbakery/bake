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
		commandRunner: CommandRunner
	) {
		self.path = path
		self.configuration = configuration
		self.scheme = scheme
		self.sdkType = sdkType
		self.commandRunner = commandRunner
	}

	let path: XcodePath
	let scheme: String
	let configuration: String
	let sdkType: SDKType
	let commandRunner: CommandRunner


	public enum Command: String {
		case build = "build"
		// case buildForTest = "build-for-testing"
		// case test = "test"
	}


	public func execute(command: Command) async throws {
		let xcodebuildCommand = "/usr/bin/xcodebuild"
		var arguments = self.arguments(command: command)  //, destination: destination, codesignIdentity: codesignIdentity, onlyTesting: onlyTesting)
		try await commandRunner.run(xcodebuildCommand, arguments: arguments, environment: [:])
	}

	func arguments(command: Command /*, destination: Destination, codesignIdentity: String? = nil, onlyTesting: String? = nil */) -> [String] {
		var parameters = [
			command.rawValue,
			"-scheme", self.scheme,
			"-configuration", "Debug",
			"-UseNewBuildSystem=YES"
			// "-derivedDataPath", xcodePath.buildDirectory.path,
			// "-disable-concurrent-destination-testing",
			// "-parallel-testing-enabled", "NO",
			// "-enableAddressSanitizer", "NO",
			// "-enableThreadSanitizer", "NO",
			// "-enableUndefinedBehaviorSanitizer", "NO",
			// "-enableCodeCoverage", "NO",
			// "-destination", destination.value,
			// "COMPILER_INDEX_STORE_ENABLE=NO",
			// "-skipMacroValidation",
			// "ARCH=arm64",
			// "DSTROOT=\(xcodePath.destinationDirectory.path)",
			// "OBJROOT=\(xcodePath.objectDirectory.path)",
			// "SYMROOT=\(xcodePath.symbolDirectory.path)",
			// "SHARED_PRECOMPS_DIR=\(xcodePath.sharedPrecompiledHeadersDirectory.path)"
		]

		// if let codesignIdentity {
		// 	if codesignIdentity == "" {
		// 		parameters.append(contentsOf: [
		// 			"CODE_SIGN_IDENTITY=",
		// 			"CODE_SIGNING_REQUIRED=NO",
		// 			"CODE_SIGNING_ALLOWED=NO"
		// 		])
		// 	} else {
		// 		parameters.append(contentsOf: [
		// 			"CODE_SIGN_IDENTITY=\(codesignIdentity)"
		// 		])
		// 	}
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
