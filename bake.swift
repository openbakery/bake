// Bake configuration

@plugin("BakeXcode", package: "bake")


let project = Project(
	name: "Bake-Example",
	jobs: [
		.command("hello", "echo", "Hello World!")
	]
)
