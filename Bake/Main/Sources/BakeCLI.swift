import ArgumentParser
import Bake
import BakeXcode
import Foundation

@main
struct BakeCLI: ParsableCommand {
	static let configuration = CommandConfiguration(
		commandName: "bake",
		abstract: "A utility for bulding and running software projects",
		version: "2026.0.0",
		subcommands: [BootstrapCommand.self])

}
