//
// Created by René Pirringer on 12.12.2025
//


class LineParser {
	private let text: String
	private var currentIndex: String.Index

	init(_ text: String) {
		self.text = text
		self.currentIndex = text.startIndex
	}

	func nextLine() -> String? {
		guard currentIndex < text.endIndex else {
			return nil
		}

		if let newlineRange = text[currentIndex...].range(of: "\n") {
			let line = String(text[currentIndex..<newlineRange.lowerBound])
			currentIndex = newlineRange.upperBound
			return line
		} else {
			let line = String(text[currentIndex...])
			currentIndex = text.endIndex
			return line.isEmpty ? nil : line
		}
	}

	func hasMoreLines() -> Bool {
		return currentIndex < text.endIndex
	}

	func reset() {
		currentIndex = text.startIndex
	}
}



open class SimulatorControlParser {

	public init() {
	}

	enum Mode {
		case deviceType, none
	}

	var mode = Mode.none

	open func parse(_ contents: String) -> Simulators? {

		let lineParser = LineParser(contents)

		var deviceTypes = [DeviceType]()

		while let line = lineParser.nextLine() {

			switch mode {
			case .none:
				if line == "== Device Types ==" {
					mode = .deviceType
				}
			case .deviceType:
				if let type = DeviceType(line) {
					deviceTypes.append(type)
				} else {
					mode = .none
				}
			}

		}

		return Simulators(deviceTypes: deviceTypes)

	}


}
