//
// Created by René Pirringer on 30.1.2026
//


extension Xcodebuild {

	public struct DefaultParameters {

		public init() {
			self.skipMacroValidation = true
			self.enableAddressSanitizer = false
			self.enableThreadSanitizer = false
			enableUndefinedBehaviorSanitizer = false
			compilerIndexStoreEnabled = false
		}

		let skipMacroValidation: Bool
		let enableAddressSanitizer: Bool
		let enableThreadSanitizer: Bool
		let enableUndefinedBehaviorSanitizer: Bool
		let compilerIndexStoreEnabled: Bool

		var parameters: [String] {
			var result = [String]()
			if skipMacroValidation {
				result.append("-skipMacroValidation")
			}

			result.append("-enableAddressSanitizer")
			result.append(enableAddressSanitizer.parameterString)

			result.append("-enableThreadSanitizer")
			result.append(enableThreadSanitizer.parameterString)

			result.append("-enableUndefinedBehaviorSanitizer")
			result.append(enableUndefinedBehaviorSanitizer.parameterString)

			result.append("COMPILER_INDEX_STORE_ENABLE=\(compilerIndexStoreEnabled.parameterString)")

			return result
		}

	}


	public struct TestParameters {

		public init() {
			disableConcurrentDestinationTesting = true
			parallelTestingEnabled = false
			enableCodeCoverage = false
		}

		let disableConcurrentDestinationTesting: Bool
		let parallelTestingEnabled: Bool
		let enableCodeCoverage: Bool

		var parameters: [String] {
			var result = [String]()
			if disableConcurrentDestinationTesting {
				result.append("-disable-concurrent-destination-testing")
			}

			result.append("-parallel-testing-enabled")
			result.append(parallelTestingEnabled.parameterString)
			result.append("-enableCodeCoverage")
			result.append(enableCodeCoverage.parameterString)

			return result

		}
	}

}
