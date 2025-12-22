import ArgumentParser
import Bake
import BakeXcode

@main
struct LocalBake: ParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "bake",
		abstract: "A utility for bulding and running software projects",
		version: "2025.0.0",
		subcommands: [Usage.self] + BakeXcode.commands,
		defaultSubcommand: Usage.self)

}


extension LocalBake {
	struct Usage: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Print the usage info.")

		mutating func run() {
			print("Usage...")
		}
	}
}
