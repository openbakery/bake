import Bake
import Foundation

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

	var customCurrentDirectoryURL: URL?
	override open var currentDirectoryURL: URL? {
		get {
			return customCurrentDirectoryURL
		}
		set {
			customCurrentDirectoryURL = newValue
		}
	}

	var customEnvironment: [String: String]?
	override open var environment: [String: String]? {
		get {
			customEnvironment
		}
		set {
			customEnvironment = newValue
		}
	}

	open var customTerminationStatus: Int32?
	override open var terminationStatus: Int32 {
		customTerminationStatus ?? 0
	}

	override open func waitUntilExit() {
	}
}
