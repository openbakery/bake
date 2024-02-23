
import Foundation
import ArgumentParser
import Bake


@main
class BakeCLI: ParsableCommand {
	//let task = Process()

	lazy var logger: Logger = Logger()

  @Argument(help: "The target to run")
  var target: String = ""

	var targets = [any Target]()

	required init() {
	}

	required init(from decoder:Decoder) throws {
	}
	

 	func run() throws {
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
