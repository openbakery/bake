import Foundation

@main
struct BakeCLI {
	//let task = Process()

  static func main() {
		BakeCLI().run()
  }

	func run() {
		print("Baking...")
		//task.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
	}

	func swift(_ arguments: String...) {
	}

}
