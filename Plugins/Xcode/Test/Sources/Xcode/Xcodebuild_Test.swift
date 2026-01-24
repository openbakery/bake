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
final class Xcodebuild_Test: Sendable {

	init() async throws {
		HamcrestSwiftTesting.enable()

		let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		path = try XcodePath(base: dir)
	}

	let path: XcodePath

	deinit {
		path.clean()
	}

	func create(scheme: String = "scheme", sdkType: SDKType = .iOS) -> Xcodebuild {
		return Xcodebuild(path: path, scheme: scheme, sdkType: sdkType)
	}

	@Test func instance_has_path() {
		// when
		let xcodebuild = create()
		// expect

		assertThat(xcodebuild.path, presentAnd(instanceOf(XcodePath.self)))
	}

	@Test(arguments: TestValue.randomValues)
	func has_scheme(value: TestValue) {

		// when
		let xcodebuild = create(scheme: value.stringValue)
		// expect

		assertThat(xcodebuild.scheme, presentAnd(equalTo(value.stringValue)))
	}

	@Test(arguments: [SDKType.iOS, SDKType.tvOS, SDKType.macOS])
	func has_sdk_type(sdkType: SDKType) {

		// when
		let xcodebuild = create(sdkType: sdkType)
		// expect

		assertThat(xcodebuild.sdkType, presentAnd(equalTo(sdkType)))
	}


}
