//
// Created by René Pirringer on 6.2.2026
//

import BakeTestHelper
import Foundation
import Hamcrest
import Testing

@testable import Bake

class CommandRunner_Job_Test {

	init() async throws {
		HamcrestSwiftTesting.enable()
	}

	@Test func create_job() throws {
		// when
		let job = Job.command(name: "build", command: "echo", "foo", "bar")

		// then
		assertThat(job.executable, instanceOf(CommandRunnerJob.self))
		assertThat(job.executable.commandRunner, presentAnd(instanceOf(CommandRunner.self)))
	}

	@Test func create_job_with_commandRunner() throws {
		let commandRunner = CommandRunnerFake()
		// when
		let job = Job.command(name: "build", command: "echo", "foo", "bar", commandRunner: commandRunner)

		// then
		assertThat(job.executable, instanceOf(CommandRunnerJob.self))
		assertThat(job.executable.commandRunner, presentAnd(instanceOf(CommandRunnerFake.self)))
	}

	@Test func create_job_execute_runs_command() async throws {
		let commandRunner = CommandRunnerFake()
		let job = Job.command(name: "build", command: "echo", "foo", "bar", commandRunner: commandRunner)

		// when
		try await job.execute()

		// then
		assertThat(commandRunner.command, presentAnd(equalTo("echo")))
		assertThat(commandRunner.arguments, presentAnd(contains("foo", "bar")))
	}
}
