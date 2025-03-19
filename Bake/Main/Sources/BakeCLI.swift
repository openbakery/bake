import ArgumentParser
import Bake
import Foundation

class TargetManager: Decodable {


	var targets = [any Target]()

	init() {
	}

	required init(from: any Decoder) throws {
	}

	public func append(_ target: any Target) {
		self.targets.append(target)
	}
}


@main
struct BakeCLI: ParsableCommand {

	public init() {
		self.init(logger: Logger())
	}

	public init(logger: Logger) {
		self.logger = logger
	}


	@Argument(help: "The target to run")
	var target: String
	let logger: Logger

	let targets = TargetManager()

	mutating func run() throws {
		// if executeTarget() {
		// 	return
		// }
		if target == "list" {
			print("Targets:")
			return
		}

		if target == "build" {
			return
		}
		printUsage()
	}

	// private func executeTarget() -> Bool {
	// 	for target in targets where target.name == self.target {
	// 		logger.message("Executing target \"\(target.name)\"")
	// 		return true
	// 	}
	// 	return false
	// }

	private func printUsage() {
		// if target.count > 0 {
		// 	logger.message("Target not found \"\(target)\"")
		// 	logger.message("")
		// }
		// logger.message("Usage: bake target [options]")
	}

}
