import ArgumentParser
import Bake
import BakePlugins
import Foundation

class TargetManager: Decodable {


	var targets = [any Target]()

	let logger: Logger

	init(logger: Logger) {
		self.logger = logger
		self.append(SimulatorControl())
	}

	required init(from: any Decoder) throws {
		fatalError("init with Decoder is not implemented")
	}

	public func append(_ target: any Target) {
		self.targets.append(target)
	}


	func executeTarget(name: String) -> Bool {
		for target in targets where target.name == name {
			logger.message("Executing target \"\(target.name)\"")
			return true
		}
		return false
	}

}


@main
struct BakeCLI: ParsableCommand {

	public init() {
		self.init(logger: Logger())
	}

	public init(logger: Logger) {
		self.logger = logger
		self.targets = TargetManager(logger: logger)
	}


	@Argument(help: "The target to run")
	var target: String
	let logger: Logger

	let targets: TargetManager

	mutating func run() throws {
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
			logger.message("Target not found \"\(target)\"")
			logger.message("")
		}
		logger.message("Usage: bake target [options]")
	}

}
