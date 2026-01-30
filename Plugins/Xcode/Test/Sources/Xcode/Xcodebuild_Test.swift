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

@Suite(.serialized)
final class Xcodebuild_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()

		let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		path = try XcodePath(base: dir)
		commandRunner = CommandRunnerFake()
	}

	let path: XcodePath
	let commandRunner: CommandRunnerFake

	deinit {
		path.clean()
	}

	func create(scheme: String = "scheme", configuration: String = "Debug", sdkType: SDKType = .iOS) -> Xcodebuild {
		return Xcodebuild(
			path: path,
			scheme: scheme,
			configuration: configuration,
			sdkType: sdkType,
			commandRunner: commandRunner)
	}

	@Test func instance_has_path() {
		// when
		let xcodebuild = create()

		// then
		assertThat(xcodebuild.path, presentAnd(instanceOf(XcodePath.self)))
	}

	@Test(arguments: TestValue.randomValues)
	func has_scheme(value: TestValue) {
		// when
		let xcodebuild = create(scheme: value.stringValue)

		// then
		assertThat(xcodebuild.scheme, presentAnd(equalTo(value.stringValue)))
	}

	@Test(arguments: TestValue.randomValues)
	func has_configuration(value: TestValue) {
		// when
		let xcodebuild = create(configuration: value.stringValue)

		// then
		assertThat(xcodebuild.configuration, presentAnd(equalTo(value.stringValue)))
	}

	@Test(arguments: [SDKType.iOS, SDKType.tvOS, SDKType.macOS])
	func has_sdk_type(sdkType: SDKType) {
		// when
		let xcodebuild = create(sdkType: sdkType)

		// then
		assertThat(xcodebuild.sdkType, presentAnd(equalTo(sdkType)))
	}

	@Test(arguments: TestValue.randomValue)
	func execute_command_build(value: TestValue) async throws {
		// given
		let xcodebuild = create(scheme: value.stringValue, configuration: value.stringValue1)

		// when
		try await xcodebuild.execute(command: .build)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		var arguments = try #require(commandRunner.arguments)

		assertThat(arguments.removeFirst(), presentAnd(equalTo("build")))
		assertThat(arguments, hasParameter("-scheme", value.stringValue))
		assertThat(arguments, hasParameter("-configuration", "Debug"))
		assertThat(arguments, hasParameter("-arch", "arm64"))
		assertThat(arguments, hasItem("-UseNewBuildSystem=YES"))
		assertThat(arguments, hasItem("-skipMacroValidation"))
		assertThat(arguments, hasParameter("-enableAddressSanitizer", "NO"))
		assertThat(arguments, hasParameter("-enableThreadSanitizer", "NO"))
		assertThat(arguments, hasParameter("-enableUndefinedBehaviorSanitizer", "NO"))
		assertThat(arguments, hasItem("COMPILER_INDEX_STORE_ENABLE=NO"))
		assertThat(arguments, hasItem("DSTROOT=\(path.destinationDirectory.path)"))
		assertThat(arguments, hasItem("OBJROOT=\(path.objectDirectory.path)"))
		assertThat(arguments, hasItem("SYMROOT=\(path.symbolDirectory.path)"))
		assertThat(arguments, hasItem("SHARED_PRECOMPS_DIR=\(path.sharedPrecompiledHeadersDirectory.path)"))

	}

	@Test(arguments: TestValue.randomValue)
	func execute_command_test(value: TestValue) async throws {
		// given
		let xcodebuild = create(scheme: value.stringValue, configuration: value.stringValue1)

		// when
		try await xcodebuild.execute(command: .test)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		var arguments = try #require(commandRunner.arguments)

		assertThat(arguments.removeFirst(), presentAnd(equalTo("test")))
		assertThat(arguments, hasParameter("-scheme", value.stringValue))
		assertThat(arguments, hasParameter("-configuration", "Debug"))
		assertThat(arguments, hasParameter("-arch", "arm64"))
		assertThat(arguments, hasItem("-UseNewBuildSystem=YES"))
		assertThat(arguments, hasItem("-disable-concurrent-destination-testing"))
		assertThat(arguments, hasParameter("-parallel-testing-enabled", "NO"))
		assertThat(arguments, hasParameter("-enableCodeCoverage", "NO"))
	}


}
