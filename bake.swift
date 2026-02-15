// Bake configuration

@plugin("BakeXcode", package: "bake")


@MainActor
let project = Project(
	name: "Bake-Example",
	jobs: [
		Job.command(name: "hello", command: "echo", "Hello World!")
	]
)
