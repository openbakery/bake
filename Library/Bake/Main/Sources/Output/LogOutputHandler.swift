//
// Created by René Pirringer on 3.1.2026
//


public actor LogOutputHandler: OutputHandler {

	public init(level: Log.Level = .info) {
		self.level = level
	}

	let level: Log.Level

	nonisolated public func process(line: String) {
		Log.log(self.level, line)
	}


}
