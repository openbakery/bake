import Bake
import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import OBExtra
import Testing

@testable import BakeXcode

final class Xcodebuild_Job_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	// func create(
	// 	command: Xcodebuild.Command = .build,
	// 	scheme: String = "scheme",
	// 	configuration: String = "Debug",
	// 	destination: Destination = .iOSGeneric,
	// 	codesigning: Codesigning = .automatic,
	// 	onlyTest: [String]? = nil
	// ) -> Xcodebuild {
	// 	return Xcodebuild(
	// 		command: command,
	// 		scheme: scheme,
	// 		configuration: configuration,
	// 		destination: destination,
	// 		codesigning: codesigning,
	// 		onlyTest: onlyTest,
	// 		xcode: XcodeSpy(commandRunner: commandRunner),
	// 		path: path)
	// }


	@Test func create_job() throws {
		// when
		let job = Job.xcodebuild(name: "build", command: .build, scheme: "", destination: .macOS)

		// then
		assertThat(job.executable, instanceOf(Xcodebuild.self))
		let xcodebuild = try #require(job.executable as? Xcodebuild)
		assertThat(xcodebuild.command, equalTo(.build))
	}
}
