//
// Created by René Pirringer on 2.2.2026
//

public class Job<T: Runnable>: Runnable {


	public init(name: String, runnable: T) {
		self.name = name
		self.executable = runnable
	}

	public let name: String
	public let executable: T
	public private(set) var dependencies = [Job]()

	public func execute() async throws {
		for job in dependencies {
			try await job.execute()
		}
		try await self.executable.execute()
	}

	public func dependsOn(_ other: Job) {
		self.dependencies.append(other)
	}

}
