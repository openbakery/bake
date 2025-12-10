//
// Created by René Pirringer on 29.10.2025
//
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import Bake

class VersionTest {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}


	@Test
	func init_with_number() {

		let versionNumbers = [
			[1, 1, 1, 1],
			[1, 2, 1, 1],
			[1, 1, 2, 1],
			[1, 1, 1, 2],
			[1, 2, 3, 4],
			[0, 1, 1, 1],
			[0, 2, 1, 1],
			[0, 1, 2, 1],
			[0, 1, 1, 2],
			[0, 2, 3, 4],
			[0, 0, 0, 1]
		]

		for versionNumber in versionNumbers {

			let version = Version(major: versionNumber[0], minor: versionNumber[1], maintenance: versionNumber[2], build: versionNumber[3])
			assertThat(version.major, equalTo(versionNumber[0]))
			assertThat(version.minor, equalTo(versionNumber[1]))
			assertThat(version.maintenance, equalTo(versionNumber[2]))
			assertThat(version.build, equalTo(versionNumber[3]))
		}

	}

	@Test func init_with_string() {

		let versionNumbers = [
			"1.1.1.1": [1, 1, 1, 1],
			"1.2.1.1": [1, 2, 1, 1],
			"1.1.2.1": [1, 1, 2, 1],
			"1.1.1.2": [1, 1, 1, 2],
			"1.2.3.4": [1, 2, 3, 4],
			"0.1.1.1": [0, 1, 1, 1],
			"0.2.1.1": [0, 2, 1, 1],
			"0.1.2.1": [0, 1, 2, 1],
			"0.1.1.2": [0, 1, 1, 2],
			"0.2.3.4": [0, 2, 3, 4],
			"0.0.0.1": [0, 0, 0, 1],
			"1": [1, 0, 0, 0],
			"1.bar": [1, 0, 0, 0],
			"1 bar": [1, 0, 0, 0],
			"1.2.4.x": [1, 2, 4, 0]
		]

		for (versionString, versionNumber) in versionNumbers {
			let version = Version(string: versionString)
			assertThat(version.major, equalTo(versionNumber[0]))
			assertThat(version.minor, equalTo(versionNumber[1]))
			assertThat(version.maintenance, equalTo(versionNumber[2]))
			assertThat(version.build, equalTo(versionNumber[3]))
		}
	}


	@Test func toString() {

		let versionStrings = [
			"1.0",
			"1.2.3",
			"1.2.3.4",
			"0.0.0.1",
			"0.0.1.1",
			"1.0.0.1"
		]

		for versionString in versionStrings {
			assertThat("\(Version(string: versionString))", equalTo(versionString))
		}
	}

	@Test func equal() {
		assertThat(Version(string: "1.0"), equalTo(Version(string: "1.0")))
		assertThat(Version(string: "1.0"), equalTo(Version(string: "1.0.0")))
		assertThat(Version(string: "1.0"), equalTo(Version(string: "1.0.0.0")))
		assertThat(Version(string: "0.0.1"), equalTo(Version(string: "0.0.1")))
		assertThat(Version(string: "0.1"), not(equalTo(Version(string: "1.0"))))
		assertThat(Version(string: "1.0.1"), not(equalTo(Version(string: "1.0.0"))))
	}



	@Test func version_is_less_then_other() {
		assertThat(Version(string: "1.0"), lessThan(Version(string: "1.1")))
		assertThat(Version(string: "1.0"), lessThan(Version(string: "2.0")))
		assertThat(Version(string: "1.0"), lessThan(Version(string: "1.1.1")))
		assertThat(Version(string: "2.0"), lessThan(Version(string: "2.1")))
		assertThat(Version(string: "1.0"), lessThan(Version(string: "1.2.1")))
		assertThat(Version(string: "1.0.0.1"), lessThan(Version(string: "1.0.0.2")))
	}

	@Test func version_is_less() {
		assertThat(Version(string: "1.0") < Version(string: "1.1"), equalTo(true))
		assertThat(Version(string: "1.0") < Version(string: "0.1"), equalTo(false))
		assertThat(Version(string: "1.0") < Version(string: "2.0"), equalTo(true))
		assertThat(Version(string: "1.0") < Version(string: "1.1.1"), equalTo(true))
		assertThat(Version(string: "2.0") < Version(string: "2.1"), equalTo(true))
		assertThat(Version(string: "1.0") < Version(string: "1.2.1"), equalTo(true))
		assertThat(Version(string: "1.0.0.1") < Version(string: "1.0.0.2"), equalTo(true))
	}

	@Test func version_is_greater_then_other() {
		assertThat(Version(string: "2.0"), greaterThan(Version(string: "1.1")))
		assertThat(Version(string: "2.1.0"), greaterThan(Version(string: "2.0")))
		assertThat(Version(string: "1.1.2"), greaterThan(Version(string: "1.1.1")))
		assertThat(Version(string: "2.2"), greaterThan(Version(string: "2.1")))
		assertThat(Version(string: "1.3"), greaterThan(Version(string: "1.2.1")))
		assertThat(Version(string: "1.0.0.2"), greaterThan(Version(string: "1.0.0.1")))
	}

	@Test func version_is_greater() {
		assertThat(Version(string: "2.0") > Version(string: "1.1"), equalTo(true))
		assertThat(Version(string: "1.0") > Version(string: "1.1"), equalTo(false))
		assertThat(Version(string: "2.1.0") > Version(string: "2.0"), equalTo(true))
		assertThat(Version(string: "1.1.2") > Version(string: "1.1.1"), equalTo(true))
		assertThat(Version(string: "2.2") > Version(string: "2.1"), equalTo(true))
		assertThat(Version(string: "1.3") > Version(string: "1.2.1"), equalTo(true))
		assertThat(Version(string: "1.0.0.2") > Version(string: "1.0.0.1"), equalTo(true))
		assertThat(Version(string: "0.0.0.2") > Version(string: "1.0.0.1"), equalTo(false))
	}

	@Test func version_is_greater_and_equal() {
		assertThat(Version(string: "2.0") >= Version(string: "1.1"), equalTo(true))
		assertThat(Version(string: "2.0") >= Version(string: "2.0"), equalTo(true))
		assertThat(Version(string: "1.0") >= Version(string: "1.1"), equalTo(false))
		assertThat(Version(string: "2.1.0") >= Version(string: "2.0"), equalTo(true))
		assertThat(Version(string: "1.1.2") >= Version(string: "1.1.1"), equalTo(true))
		assertThat(Version(string: "1.1.2") >= Version(string: "1.1.2"), equalTo(true))
		assertThat(Version(string: "2.2") >= Version(string: "2.1"), equalTo(true))
		assertThat(Version(string: "1.3") >= Version(string: "1.2.1"), equalTo(true))
		assertThat(Version(string: "1.0.0.2") >= Version(string: "1.0.0.1"), equalTo(true))
		assertThat(Version(string: "1.0.0.1") >= Version(string: "1.0.0.1"), equalTo(true))
		assertThat(Version(string: "0.0.0.2") >= Version(string: "1.0.0.1"), equalTo(false))
	}
}
