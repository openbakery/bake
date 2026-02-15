import ArgumentParser

public struct Project {

	public init(name: String, jobs: [any Runnable] = []) {
		self.name = name
		self.jobs = jobs
	}

	let name: String
	let jobs: [any Runnable]


}


extension Project {

	public static let commands: [AsyncParsableCommand.Type] = [ProjectCommandList.self]

}
