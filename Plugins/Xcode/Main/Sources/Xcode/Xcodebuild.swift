//
// Created by René Pirringer on 8.8.2025
//


public struct Xcodebuild: Sendable {

	public init(path: XcodePath, scheme: String, sdkType: SDKType) {
		self.path = path
		self.scheme = scheme
		self.sdkType = sdkType
	}

	let path: XcodePath
	let scheme: String
	let sdkType: SDKType

	/*
	let xcodePath: XcodePath
	let scheme: String
	let platform: String

	enum Command: String {
		case buildForTest = "build-for-testing"
		case test = "test"
	}


	func execute(
		command: Command, destination: Destination = .iOSGeneric, codesignIdentity: String? = nil, onlyTesting: String? = nil, environment: [String: String]
	) async throws {

		var parameters = self.parameters(command: command, destination: destination, codesignIdentity: codesignIdentity, onlyTesting: onlyTesting)

		print("xcodebuild \(parameters.joined(separator: " "))")

		let commandRunner = await CommandRunner()

		let xcodebuildCommand = "/usr/bin/xcodebuild"
		await try commandRunner.run(xcodebuildCommand, arguments: parameters, environment: environment)


	}

	func parameters(command: Command, destination: Destination, codesignIdentity: String? = nil, onlyTesting: String? = nil) -> [String] {
		var parameters = [
			command.rawValue,
			"-scheme", self.scheme,
			"-configuration", "Debug",
			"-UseNewBuildSystem=YES",
			"-derivedDataPath", xcodePath.buildDirectory.path,
			"-disable-concurrent-destination-testing",
			"-parallel-testing-enabled", "NO",
			"-enableAddressSanitizer", "NO",
			"-enableThreadSanitizer", "NO",
			"-enableUndefinedBehaviorSanitizer", "NO",
			"-enableCodeCoverage", "NO",
			"-destination", destination.value,
			"COMPILER_INDEX_STORE_ENABLE=NO",
			"-skipMacroValidation",
			"ARCH=arm64",
			"DSTROOT=\(xcodePath.destinationDirectory.path)",
			"OBJROOT=\(xcodePath.objectDirectory.path)",
			"SYMROOT=\(xcodePath.symbolDirectory.path)",
			"SHARED_PRECOMPS_DIR=\(xcodePath.sharedPrecompiledHeadersDirectory.path)"
		]

		if let codesignIdentity {
			if codesignIdentity == "" {
				parameters.append(contentsOf: [
					"CODE_SIGN_IDENTITY=",
					"CODE_SIGNING_REQUIRED=NO",
					"CODE_SIGNING_ALLOWED=NO"
				])
			} else {
				parameters.append(contentsOf: [
					"CODE_SIGN_IDENTITY=\(codesignIdentity)"
				])
			}
		} else {
			parameters.append(contentsOf: ["-allowProvisioningUpdates"])

		}

		if let onlyTesting {
			parameters.append(contentsOf: ["-only-testing:\(scheme)/\(onlyTesting)"])

		}

		return parameters
	}

	*/
}
