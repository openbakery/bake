//
// Created by René Pirringer on 8.8.2025
//


import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakeXcode

final class Xcodebuild_Parameters_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test(arguments: [true, false])
	func update_default_parameters(value: Bool) {
		let parameters = Xcodebuild.DefaultParameters()

		assertThat(parameters.update(skipMacroValidation: value).skipMacroValidation, equalTo(value))
		assertThat(parameters.update(enableAddressSanitizer: value).enableAddressSanitizer, equalTo(value))
		assertThat(parameters.update(enableThreadSanitizer: value).enableThreadSanitizer, equalTo(value))
		assertThat(parameters.update(enableUndefinedBehaviorSanitizer: value).enableUndefinedBehaviorSanitizer, equalTo(value))
		assertThat(parameters.update(compilerIndexStoreEnabled: value).compilerIndexStoreEnabled, equalTo(value))
	}

	@Test(arguments: [true, false])
	func update_test_parameters(value: Bool) {
		let parameters = Xcodebuild.TestParameters()

		assertThat(parameters.update(disableConcurrentDestinationTesting: value).disableConcurrentDestinationTesting, equalTo(value))
		assertThat(parameters.update(parallelTestingEnabled: value).parallelTestingEnabled, equalTo(value))
		assertThat(parameters.update(enableCodeCoverage: value).enableCodeCoverage, equalTo(value))
	}

}
