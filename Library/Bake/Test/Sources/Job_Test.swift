//
// Created by René Pirringer on 3.2.2026
//

import Foundation
import Hamcrest
import HamcrestSwiftTesting
import Testing

@testable import Bake

struct Job_Test {

	func create(
		name: String = "Build",
		executable: Executable = MessageOutput(message: "foobar")
	) -> Job {
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

}
