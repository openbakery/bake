//
// Created by René Pirringer on 2.2.2026
//

public class Job {

	public init(name: String, executable: any Executable) {
		self.name = name
		self.executable = executable
	}

	let name: String
	let executable: any Executable
	var dependencies = [Job]()

	func execute() async throws {
		for job in dependencies {
			try await job.execute()
		}
		try await self.executable.execute()
	}

	public func dependsOn(_ other: Job) {
		self.dependencies.append(other)
	}

}
