
import Foundation
import ArgumentParser


@main
struct BakeCLI: ParsableCommand {
	//let task = Process()

	let logger: Logger

  @Argument(help: "The command to run")
  public var command: String

	init() {
		self.logger = Logger()
	}

	init(logger: Logger) {
		self.logger = logger
	}


 	func run() throws {
		if command == "build" {
			return
		}
		printUsage()
	}

	private func printUsage() {
		if command.count > 0 {
			logger.message("Command not found \"\(command)\"")
			logger.message("")
		}
		logger.message("Usage: bake [options] command")
	}




}
