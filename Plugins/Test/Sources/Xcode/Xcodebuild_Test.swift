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

@testable import BakePlugins

@Suite(.serialized)
final class Xcodebuild_Test: Sendable {

	init() async throws {
		HamcrestSwiftTesting.enable()

		let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		path = try XcodePath(base: dir)
		xcodebuild = Xcodebuild(path: path)
	}

	let xcodebuild: Xcodebuild
	let path: XcodePath

	deinit {
		path.clean()
	}

	@Test func instance_has_path() {
		// expect
		assertThat(xcodebuild.path, presentAnd(instanceOf(XcodePath.self)))
	}

}
