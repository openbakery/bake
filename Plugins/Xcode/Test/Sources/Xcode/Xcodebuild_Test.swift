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
		path = try XcodeBuildPaths(base: dir)
		commandRunner = CommandRunnerFake()
	}

	let path: XcodeBuildPaths
	let commandRunner: CommandRunnerFake

	deinit {
		path.clean()
	}

	func create(
		scheme: String = "scheme",
		configuration: String = "Debug",
		sdkType: SDKType = .iOS,
		codesigning: Codesigning = .automatic,
		onlyTest: [String]? = nil
	) -> Xcodebuild {
		return Xcodebuild(
			path: path,
			xcode: XcodeSpy(commandRunner: commandRunner),
			scheme: scheme,
			configuration: configuration,
			sdkType: sdkType,
			codesigning: codesigning,
			onlyTest: onlyTest)
	}

	@Test func instance_has_path() {
		// when
		let xcodebuild = create()

		// then
		assertThat(xcodebuild.path, presentAnd(instanceOf(XcodeBuildPaths.self)))
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

	func default_configuration_is_debug() {
		// when
		let xcodebuild = Xcodebuild(
			path: path,
			xcode: XcodeSpy(commandRunner: commandRunner),
			scheme: "scheme",
			sdkType: .iOS)

		// then
		assertThat(xcodebuild.configuration, presentAnd(equalTo("Debug")))
	}

	func destination_defines_sdk_type() {
		// when
		let xcodebuild = Xcodebuild(
			path: path,
			xcode: XcodeSpy(commandRunner: commandRunner),
			scheme: "scheme",
			destination: Destination.iOSGeneric)

		// then
		assertThat(xcodebuild.configuration, presentAnd(equalTo("Debug")))
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
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("build")))
		assertThat(arguments, hasParameter("-scheme", value.stringValue))
		assertThat(arguments, hasParameter("-configuration", "Debug"))
		assertThat(arguments, not(hasParameter("-arch", "arm64")))
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
		assertThat(arguments, hasParameter("-destination", "generic/platform=iOS"))
		assertThat(arguments, hasItem("-allowProvisioningUpdates"))
	}

	@Test(arguments: TestValue.randomValue)
	func execute_command_test(value: TestValue) async throws {
		// given
		let xcodebuild = create(scheme: value.stringValue, configuration: value.stringValue1)

		// when
		try await xcodebuild.execute(command: .test)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("test")))
		assertThat(arguments, hasParameter("-scheme", value.stringValue))
		assertThat(arguments, hasParameter("-configuration", "Debug"))
		assertThat(arguments, hasItem("-UseNewBuildSystem=YES"))
		assertThat(arguments, hasItem("-disable-concurrent-destination-testing"))
		assertThat(arguments, hasParameter("-parallel-testing-enabled", "NO"))
		assertThat(arguments, hasParameter("-enableCodeCoverage", "NO"))
		assertThat(arguments, hasParameter("-destination", "generic/platform=iOS"))
	}

	@Test(arguments: [
		Destination(type: .iOS, identifier: "234-234"),
		Destination(type: .iOS, identifier: "234-234", architecture: .arm64)
	])
	func execute_command_with_different_destinations(destination: Destination) async throws {
		// given
		let xcodebuild = Xcodebuild(path: path, xcode: XcodeSpy(commandRunner: commandRunner), scheme: "", configuration: "", destination: destination)

		// when
		try await xcodebuild.execute(command: .build)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments, hasParameter("-destination", destination.value))
	}

	@Test
	func execute_command_has_codesign_identity() async throws {
		// given
		let xcodebuild = create(scheme: "", configuration: "", codesigning: .identity("1234"))

		// when
		try await xcodebuild.execute(command: .build)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("build")))
		assertThat(arguments, hasItem("CODE_SIGN_IDENTITY=1234"))
	}

	@Test
	func execute_command_has_empty_codesign_identity() async throws {
		// given
		let xcodebuild = create(scheme: "", configuration: "", codesigning: .none)

		// when
		try await xcodebuild.execute(command: .build)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("build")))
		assertThat(arguments, hasItem("CODE_SIGN_IDENTITY="))
		assertThat(arguments, hasItem("CODE_SIGNING_REQUIRED=NO"))
		assertThat(arguments, hasItem("CODE_SIGNING_ALLOWED=NO"))
	}

	@Test
	func execute_command_test_with_onlyTest() async throws {
		// given
		let xcodebuild = create(scheme: "app", onlyTest: ["foo/bar"])

		// when
		try await xcodebuild.execute(command: .test)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("test")))
		assertThat(arguments, hasItem("-only-testing:app/foo/bar"))
	}

	@Test
	func execute_command_test_with_multiple_onlyTest() async throws {
		// given
		let xcodebuild = create(scheme: "app", onlyTest: ["foo/1", "foo/2", "foo/3"])

		// when
		try await xcodebuild.execute(command: .test)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("test")))
		assertThat(arguments, hasItem("-only-testing:app/foo/1"))
		assertThat(arguments, hasItem("-only-testing:app/foo/2"))
		assertThat(arguments, hasItem("-only-testing:app/foo/3"))
	}

	@Test
	func execute_command_build_ignores_test_parameter() async throws {
		// given
		let xcodebuild = create(scheme: "app", onlyTest: ["foo/bar"])

		// when
		try await xcodebuild.execute(command: .build)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("build")))
		assertThat(arguments, not(hasItem("-only-testing:app/foo/bar")))
		assertThat(arguments, not(hasParameter("-enableCodeCoverage", "NO")))
	}

	@Test
	func execute_command_build_for_test_ignores_test_parameter() async throws {
		// given
		let xcodebuild = create(scheme: "app", onlyTest: ["foo/bar"])

		// when
		try await xcodebuild.execute(command: .buildForTest)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(arguments.first, presentAnd(equalTo("build-for-testing")))
		assertThat(arguments, not(hasItem("-only-testing:app/foo/bar")))
		assertThat(arguments, not(hasParameter("-enableCodeCoverage", "NO")))
	}

	@Test func update() {
		// given
		let xcodebuild = create(scheme: "app", configuration: "Debug")
			.update(scheme: "test")
		assertThat(xcodebuild.scheme, equalTo("test"))
		assertThat(xcodebuild.configuration, equalTo("Debug"))

		assertThat(xcodebuild.update(configuration: "Release").configuration, equalTo("Release"))
		assertThat(xcodebuild.update(sdkType: .macOS).sdkType, equalTo(.macOS))
		assertThat(xcodebuild.update(destination: SDKType.watchOS.genericDestination).destination?.value, presentAnd(hasSuffix("watchOS")))
		assertThat(xcodebuild.update(codesigning: Codesigning.none).codesigning, presentAnd(equalTo(.none)))
		assertThat(xcodebuild.update(onlyTest: ["foo"]).onlyTest, equalTo(["foo"]))
		assertThat(xcodebuild.update(defaultParameters: .default.update(skipMacroValidation: false)).defaultParameters.skipMacroValidation, equalTo(false))
		assertThat(xcodebuild.update(testParameters: .default.update(enableCodeCoverage: false)).testParameters.enableCodeCoverage, equalTo(false))
	}

	@Test
	func arch_is_added_when_destination_is_missing() async throws {
		// given
		let xcodebuild = create(sdkType: .macOS)

		// when
		try await xcodebuild.execute(command: .build)

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("/usr/bin/xcodebuild")))
		let arguments = try #require(commandRunner.arguments)

		assertThat(xcodebuild.destination, nilValue())
		assertThat(arguments.first, presentAnd(equalTo("build")))
		assertThat(arguments, hasParameter("-configuration", "Debug"))
		assertThat(arguments, hasParameter("-arch", "arm64"))
	}

	@Test
	func execute_prepares_the_xcodeBuildPaths() async throws {
		let base = FileManager.default.temporaryDirectory.appendingPathComponent("bake_test")
		let path = XcodeBuildPaths(base: base)
		defer {
			path.clean()
		}
		let xcodebuild = Xcodebuild(
			path: path,
			xcode: XcodeSpy(commandRunner: commandRunner),
			scheme: "",
			sdkType: .iOS)

		// when
		try await xcodebuild.execute(command: .build)

		// expect
		let expectedUrl = base.appendingPathComponent("build")
		assertThat(path.buildDirectory, presentAnd(equalTo(expectedUrl)))
		assertThat(path.buildDirectory.fileExists(), equalTo(true))
	}
}
