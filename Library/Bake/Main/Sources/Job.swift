//
// Created by René Pirringer on 2.2.2026
//

public struct Job {

	public init(name: String, executable: any Executable) {
		self.name = name
		self.executable = executable
	}

	let name: String
	let executable: any Executable

	func execute() async throws {
		try await self.executable.execute()
	}

}
