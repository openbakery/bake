import Foundation

@testable import Bake

open class ProcessFake: Process, @unchecked Sendable {

	override public init() {
	}

	public var wasExecuted = false
	public var argumentsFake: [String]?
	public var executeableURLFake: URL?

	override open func run() throws {
		wasExecuted = true
	}

	override open var launchPath: String? {
		get {
			return nil
		}
		set {
		}
	}

	override open var arguments: [String]? {
		get {
			argumentsFake
		}
		set {
			argumentsFake = newValue
		}
	}

	override open var executableURL: URL? {
		get {
			executeableURLFake
		}
		set {
			executeableURLFake = newValue
		}
	}

	override open var standardError: Any? {
		get {
			return nil
		}
		set {
		}
	}

	override open var standardInput: Any? {
		get {
			return nil
		}
		set {
		}
	}

	override open var standardOutput: Any? {
		get {
			return nil
		}
		set {
		}
	}
}
