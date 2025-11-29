//
// Created by René Pirringer on 28.11.2025
//
import Foundation

public class Log {

	public init() {
		self.outputHandler = nil
	}

	public enum Level: Sendable, CustomStringConvertible {
		case error, info, warn, debug

		public var description: String {
			switch self {
			case .error:
				return "Error"
			case .debug:
				return "Debug"
			case .info:
				return "Info"
			case .warn:
				return "Warn"
			}
		}
	}

	public var outputHandler: OutputHandler?
	public var showLevel = false

	@MainActor public static let instance = Log()


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

	public func log(level: Level, message: String) {
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

	public static func log(level: Level, message: String) {

		if Thread.isMainThread {
			MainActor.assumeIsolated {
				Log.instance.log(level: level, message: message)
			}
		} else {
			Task { @MainActor in
				Log.instance.log(level: level, message: message)
			}
		}

	}

	public static func debug(_ message: String) {
		self.log(level: .debug, message: message)

		// logFunction(

	}


}
