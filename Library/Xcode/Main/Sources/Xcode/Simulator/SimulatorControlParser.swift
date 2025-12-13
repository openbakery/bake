//
// Created by René Pirringer on 12.12.2025
//


class LineParser {
	private let text: String
	private var currentIndex: String.Index
	private var previousIndex: String.Index

	init(_ text: String) {
		self.text = text
		self.currentIndex = text.startIndex
		self.previousIndex = text.startIndex
	}

	func nextLine() -> String? {
		guard currentIndex < text.endIndex else {
			return nil
		}

		if let newlineRange = text[currentIndex...].range(of: "\n") {
			let line = String(text[currentIndex..<newlineRange.lowerBound])
			previousIndex = currentIndex
			currentIndex = newlineRange.upperBound
			return line
		} else {
			let line = String(text[currentIndex...])
			currentIndex = text.endIndex
			previousIndex = currentIndex
			return line.isEmpty ? nil : line
		}
	}

	func hasMoreLines() -> Bool {
		return currentIndex < text.endIndex
	}

	func reset() {
		currentIndex = text.startIndex
	}

	func oneBack() {
		currentIndex = previousIndex

	}
}



open class SimulatorControlParser {

	public init() {
	}

	enum Mode {
		case deviceType, runtime, none
	}

	var mode = Mode.none

	// use the text representation for simctl -list because with Xcode 26.0 the json does not contain all data
	open func parse(_ contents: String) -> Simulators? {

		let lineParser = LineParser(contents)

		var deviceTypes = [DeviceType]()
		var runtimes = [Runtime]()


		while let line = lineParser.nextLine() {

			switch mode {
			case .none:
				if line == "== Device Types ==" {
					mode = .deviceType
				}
				if line == "== Runtimes ==" {
					mode = .runtime
				}
				print("line - \(line)")
			case .deviceType:
				if let type = DeviceType(line) {
					deviceTypes.append(type)
				} else {
					mode = .none
					lineParser.oneBack()
				}
			case .runtime:
				print("mode: runtime")
				if let runtime = Runtime(line) {
					runtimes.append(runtime)
				} else {
					mode = .none
					lineParser.oneBack()
				}
			}

		}

		return Simulators(deviceTypes: deviceTypes, runtimes: runtimes)

	}



}
