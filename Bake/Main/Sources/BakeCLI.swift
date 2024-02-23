
import Foundation
import ArgumentParser
import Bake


@main
struct BakeCLI: ParsableCommand {
	//let task = Process()

	let logger: Logger

  @Argument(help: "The target to run")
  var target: String = ""

	var targets = [Target]()

	init() {
		self.logger = Logger()
	}

	init(logger: Logger) {
		self.logger = logger
	}


 	mutating func run() throws {
		if executeTarget() {
			return
		}

		if target == "build" {
			return
		}
		printUsage()
	}

	private func executeTarget() -> Bool {
		for target in self.targets {
			if target.name == self.target {
				logger.message("Executing target \"\(target.name)\"")
				return true
			}
		}
		return false
	}

	private func printUsage() {
		if target.count > 0 {
			logger.message("Target not found \"\(target)\"")
			logger.message("")
		}
		logger.message("Usage: bake target [options]")
	}




}
