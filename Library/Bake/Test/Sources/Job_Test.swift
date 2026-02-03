//
// Created by René Pirringer on 3.2.2026
//

import BakeTestHelper
import Foundation
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import Bake

struct Job_Test {

	func create(
		name: String = "Build",
		executable: MessageOutput = MessageOutput(message: "foobar")
	) -> Job<MessageOutput> {
		return Job(name: name, executable: executable)
	}

	@Test func has_name() {

		let job = create(name: "Build")

		// then
		assertThat(job.name, equalTo("Build"))
	}

	@Test func job_with_executable() {
		let job = create()

		// then
		assertThat(job.executable, instanceOf(MessageOutput.self))
	}


	@Test func execute_job_runs_executable() async throws {
		let outputHandler = StringOutputHandler()
		let executable = MessageOutput(message: "foobar", outputHandler: outputHandler)
		let job = create(executable: executable)

		// when
		try await job.execute()

		// then
		assertThat(outputHandler.lines.first, presentAnd(equalTo("foobar")))
	}

	@Test(arguments: TestValue.randomValues)
	func simple_job_creation(value: TestValue) async throws {
		let outputHandler = StringOutputHandler()

		let job: Job = .message(name: value.stringValue, message: value.stringValue1, outputHandler: outputHandler)

		// then
		assertThat(job.name, equalTo(value.stringValue))

		// when
		try await job.execute()

		// then
		assertThat(outputHandler.lines.first, presentAnd(equalTo(value.stringValue1)))
	}


	@Test func first_job_depends_on_job_second() async throws {
		let outputHandler = StringOutputHandler()
		let first = Job.message(name: "first", message: "first", outputHandler: outputHandler)
		let second = Job.message(name: "second", message: "second", outputHandler: outputHandler)

		// when
		first.dependsOn(second)
		try await first.execute()

		// then
		assertThat(outputHandler.lines.first, presentAnd(equalTo("second")))
		assertThat(outputHandler.lines.last, presentAnd(equalTo("first")))
	}

	@Test func first_job_depends_on_job_second_and_second_on_thrid() async throws {
		let outputHandler = StringOutputHandler()
		let first = Job.message(name: "first", message: "first", outputHandler: outputHandler)
		let second = Job.message(name: "second", message: "second", outputHandler: outputHandler)
		let third = Job.message(name: "third", message: "third", outputHandler: outputHandler)

		// when
		first.dependsOn(second)
		second.dependsOn(third)
		try await first.execute()

		// then
		let lines = outputHandler.lines
		assertThat(lines.count, equalTo(3))
		guard lines.count == 3 else { return }
		assertThat(lines[0], presentAnd(equalTo("third")))
		assertThat(lines[1], presentAnd(equalTo("second")))
		assertThat(lines[2], presentAnd(equalTo("first")))
	}
}
