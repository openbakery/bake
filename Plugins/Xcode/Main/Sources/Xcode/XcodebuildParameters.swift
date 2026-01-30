//
// Created by René Pirringer on 30.1.2026
//


extension Xcodebuild {

	public struct DefaultParameters {

		public init(
			skipMacroValidation: Bool = true,
			enableAddressSanitizer: Bool = false,
			enableThreadSanitizer: Bool = false,
			enableUndefinedBehaviorSanitizer: Bool = false,
			compilerIndexStoreEnabled: Bool = false
		) {
			self.skipMacroValidation = skipMacroValidation
			self.enableAddressSanitizer = enableAddressSanitizer
			self.enableThreadSanitizer = enableThreadSanitizer
			self.enableUndefinedBehaviorSanitizer = enableUndefinedBehaviorSanitizer
			self.compilerIndexStoreEnabled = compilerIndexStoreEnabled
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

		public func update(
			skipMacroValidation: Bool? = nil,
			enableAddressSanitizer: Bool? = nil,
			enableThreadSanitizer: Bool? = nil,
			enableUndefinedBehaviorSanitizer: Bool? = nil,
			compilerIndexStoreEnabled: Bool? = nil
		) -> DefaultParameters {
			return DefaultParameters(
				skipMacroValidation: skipMacroValidation ?? self.skipMacroValidation,
				enableAddressSanitizer: enableAddressSanitizer ?? self.enableAddressSanitizer,
				enableThreadSanitizer: enableThreadSanitizer ?? self.enableThreadSanitizer,
				enableUndefinedBehaviorSanitizer: enableUndefinedBehaviorSanitizer ?? self.enableUndefinedBehaviorSanitizer,
				compilerIndexStoreEnabled: compilerIndexStoreEnabled ?? self.compilerIndexStoreEnabled
			)
		}
	}


	public struct TestParameters {

		public init(
			disableConcurrentDestinationTesting: Bool = true,
			parallelTestingEnabled: Bool = false,
			enableCodeCoverage: Bool = false,
		) {
			self.disableConcurrentDestinationTesting = disableConcurrentDestinationTesting
			self.parallelTestingEnabled = parallelTestingEnabled
			self.enableCodeCoverage = enableCodeCoverage
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

		public func update(
			disableConcurrentDestinationTesting: Bool? = nil,
			parallelTestingEnabled: Bool? = nil,
			enableCodeCoverage: Bool? = nil,
		) -> TestParameters {
			return TestParameters(
				disableConcurrentDestinationTesting: disableConcurrentDestinationTesting ?? self.disableConcurrentDestinationTesting,
				parallelTestingEnabled: parallelTestingEnabled ?? self.parallelTestingEnabled,
				enableCodeCoverage: enableCodeCoverage ?? self.enableCodeCoverage
			)
		}
	}

}
