//
// Created by René Pirringer on 28.11.2025
//
import Foundation

public class Log {

	public init(outputHandler: OutputHandler? = PrintOutputHandler(), level: Level = .info) {
		self.outputHandler = outputHandler
		self.level = level
	}

	public enum Level: Int, Sendable, CustomStringConvertible {
		case off = 0
		case error = 1
		case warn = 2
		case info = 3
		case debug = 4

		public var description: String {
			switch self {
			case .error:
				return "Error"
			case .debug:
				return "Debug"
			case .info:
				return "Info"
			case .off:
				return "Off"
			case .warn:
				return "Warn"
			}
		}
	}

	public var outputHandler: OutputHandler?
	public var showLevel = false
	public var level: Level

	@MainActor public static let instance = Log()

	@MainActor
	public static var level: Level {
		get {
			instance.level
		}
		set {
			instance.level = newValue
		}
	}


	@MainActor
	func set(outputHandler: OutputHandler) {
		self.outputHandler = outputHandler
	}


	private func format(level: Level, message: String) -> String {
		if showLevel {
			return "[\(level.description.uppercased())] - \(message)"
		}
		return message
	}

	public func log(_ level: Level, _ message: String) {
		guard level.rawValue <= self.level.rawValue else { return }
		let handler = self.outputHandler
		let string = format(level: level, message: message)

		if Thread.isMainThread {
			MainActor.assumeIsolated {
				handler?.process(line: string)
			}
		} else {
			Task { @MainActor in
				handler?.process(line: string)
			}
		}

	}

	@MainActor
	static var showLevel: Bool {
		get { Log.instance.showLevel }
		set { Log.instance.showLevel = newValue }
	}

	public static func log(_ level: Level, _ message: String) {

		if Thread.isMainThread {
			MainActor.assumeIsolated {
				Log.instance.log(level, message)
			}
		} else {
			Task { @MainActor in
				Log.instance.log(level, message)
			}
		}

	}

	public static func debug(_ message: String) {
		self.log(.debug, message)
	}

	public static func info(_ message: String) {
		self.log(.info, message)
	}

}
