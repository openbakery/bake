import Foundation

@testable import Bake

class ProcessFake: Process, @unchecked Sendable {

	var wasExecuted = false
	var argumentsFake: [String]?
	var executeableURLFake: URL?

	override func run() throws {
		wasExecuted = true
	}

	override var launchPath: String? {
		get {
			return nil
		}
		set {
		}
	}

	override var arguments: [String]? {
		get {
			argumentsFake
		}
		set {
			argumentsFake = newValue
		}
	}

	override var executableURL: URL? {
		get {
			executeableURLFake
		}
		set {
			executeableURLFake = newValue
		}
	}

	override var standardError: Any? {
		get {
			return nil
		}
		set {
		}
	}

	override var standardInput: Any? {
		get {
			return nil
		}
		set {
		}
	}

	override var standardOutput: Any? {
		get {
			return nil
		}
		set {
		}
	}
}
