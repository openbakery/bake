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

			let version = Version(major: versionNumber[0], minor: versionNumber[1], maintenance: versionNumber[2], build: "\(versionNumber[3])")
			assertThat(version.major, equalTo(versionNumber[0]))
			assertThat(version.minor, equalTo(versionNumber[1]))
			assertThat(version.maintenance, equalTo(versionNumber[2]))
			assertThat(version.build, equalTo("\(versionNumber[3])"))
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
			"0.0.0.1": [0, 0, 0, 1]
		]

		for (versionString, versionNumber) in versionNumbers {
			let version = Version(string: versionString)
			assertThat(version.major, equalTo(versionNumber[0]))
			assertThat(version.minor, presentAnd(equalTo(versionNumber[1])))
			assertThat(version.maintenance, presentAnd(equalTo(versionNumber[2])))
		}
	}

	@Test func init_with_major_only() {
		let version = Version(string: "1")
		assertThat(version.major, equalTo(1))
		assertThat(version.minor, nilValue())
		assertThat(version.maintenance, nilValue())
	}

	@Test func build() {
		let version = Version(string: "1.0.0.foobar")

		assertThat(version.major, equalTo(1))
		assertThat(version.build, equalTo("foobar"))

	}


	@Test func toString() {

		let versionStrings = [
			"1.0",
			"1.2.3",
			"1.2.3",
			"0.0.0",
			"0.0.1",
			"1.0.0"
		]

		for versionString in versionStrings {
			assertThat("\(Version(string: versionString))", equalTo(versionString))
		}
	}

	@Test func fullVersionString() {
		assertThat(Version(string: "1.2.3.4").fullVersionString, equalTo("1.2.3 - (4)"))
	}

	@Test func equal() {
		assertThat(Version(string: "1.0"), equalTo(Version(string: "1.0")))
		assertThat(Version(string: "1.0"), equalTo(Version(string: "1.0")))
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
	}

	@Test func version_is_less() {
		assertThat(Version(string: "1.0") < Version(string: "1.1"), equalTo(true))
		assertThat(Version(string: "1.0") < Version(string: "0.1"), equalTo(false))
		assertThat(Version(string: "1.0") < Version(string: "2.0"), equalTo(true))
		assertThat(Version(string: "1.0") < Version(string: "1.1.1"), equalTo(true))
		assertThat(Version(string: "2.0") < Version(string: "2.1"), equalTo(true))
		assertThat(Version(string: "1.0") < Version(string: "1.2.1"), equalTo(true))
	}

	@Test func version_is_greater_then_other() {
		assertThat(Version(string: "2.0"), greaterThan(Version(string: "1.1")))
		assertThat(Version(string: "2.1.0"), greaterThan(Version(string: "2.0")))
		assertThat(Version(string: "1.1.2"), greaterThan(Version(string: "1.1.1")))
		assertThat(Version(string: "2.2"), greaterThan(Version(string: "2.1")))
		assertThat(Version(string: "1.3"), greaterThan(Version(string: "1.2.1")))
	}

	@Test func version_is_greater() {
		assertThat(Version(string: "2.0") > Version(string: "1.1"), equalTo(true))
		assertThat(Version(string: "1.0") > Version(string: "1.1"), equalTo(false))
		assertThat(Version(string: "2.1.0") > Version(string: "2.0"), equalTo(true))
		assertThat(Version(string: "1.1.2") > Version(string: "1.1.1"), equalTo(true))
		assertThat(Version(string: "2.2") > Version(string: "2.1"), equalTo(true))
		assertThat(Version(string: "1.3") > Version(string: "1.2.1"), equalTo(true))
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

	@Test func compare() {
		let first = Version(string: "18.6", build: "22G86")
		let second = Version(string: "18.6")

		// then
		assertThat(first, equalTo(second))
	}

	@Test func compare_with_build() {
		let first = Version(string: "18.6", build: "22G86")
		let second = Version(string: "18.6", build: "asdf")

		// then
		assertThat(first, not(equalTo(second)))
	}
}
