//
// Created by René Pirringer on 11.7.2025
//

import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakePlugins

struct XcodePaths_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func default_base_is_current_directory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		assertThat(path.baseDirectory, presentAnd(equalTo(expectedUrl)))
	}

	@Test func has_build_buildDirectory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build")
		assertThat(path.buildDirectory, presentAnd(equalTo(expectedUrl)))
	}


	@Test func has_symbol_directory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/sym")
		assertThat(path.symbolDirectory, presentAnd(equalTo(expectedUrl)))
	}

	@Test func has_destination_directory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/dst")
		assertThat(path.destinationDirectory, presentAnd(equalTo(expectedUrl)))
	}

	@Test func has_object_directory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/obj")
		assertThat(path.objectDirectory, presentAnd(equalTo(expectedUrl)))
	}

	@Test func has_sharedPrecompiledHeaders_directory() {
		// when
		let path = XcodePath()

		// then
		let expectedUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/shared")
		assertThat(path.sharedPrecompiledHeadersDirectory, presentAnd(equalTo(expectedUrl)))
	}


	@Test func create_creates_the_directories() {
		let path = XcodePath()

		//  when
		path.prepare()

		// then
		assertThat(URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/sym").fileExists(), equalTo(true))
		assertThat(URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/dst").fileExists(), equalTo(true))
		assertThat(URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/obj").fileExists(), equalTo(true))
		assertThat(URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("build/shared").fileExists(), equalTo(true))


	}
}
