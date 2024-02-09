
import Foundation
import ArgumentParser


@main
struct BakeCLI: ParsableCommand {
	//let task = Process()

	let logger: Logger

	init() {
		self.logger = Logger()
	}

	init(logger: Logger) {
		self.logger = logger
	}


  // static func main() {
		// var bake = BakeCLI()
		// do {
		// 	try bake.run()
		// } catch {
		// 	bake.logger.message(error.localizedDescription)
		// }
  // }
  //

  public func run() throws {
		logger.message("Usage: bake [options] command")
	}



}
