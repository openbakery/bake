import ArgumentParser
import Bake
import BakePlugins
import Foundation

class TargetManager: Decodable {


	var targets = [any Target]()

	let output: OutputHandler

	init(outputHandler: OutputHandler) {
		self.output = outputHandler
		let commandRunner = CommandRunner()
		self.append(SimulatorControl(commandRunner: commandRunner))
	}
	required init(from: any Decoder) throws {
		fatalError("init with Decoder is not implemented")
	}

	public func append(_ target: any Target) {
		self.targets.append(target)
	}


	func executeTarget(name: String) -> Bool {
		for target in targets where target.name == name {
			output.process(line: "Executing target \"\(target.name)\"")
			return true
		}
		return false
	}

}


@main
struct BakeCLI: ParsableCommand {

	public init() {
		self.init(outputHandler: PrintOutputHandler())
	}


	public init(outputHandler: OutputHandler) {
		self.output = outputHandler
		self.targets = TargetManager(outputHandler: outputHandler)
	}

	public init(from: any Decoder) throws {
		fatalError("init with Decoder is not implemented")
	}

	@Argument(help: "The target to run")
	var target: String
	let output: OutputHandler

	let targets: TargetManager

	func run() throws {
		if executeTarget() {
			return
		}
		if target == "list" {
			print("Targets:")
			return
		}

		if target == "build" {
			return
		}
		printUsage()
	}

	private func executeTarget() -> Bool {
		return self.targets.executeTarget(name: self.target)
	}

	private func printUsage() {
		if target.count > 0 {
			output.process(line: "Target not found \"\(target)\"")
			output.process(line: "")
		}
		output.process(line: "Usage: bake target [options]")
	}

}
