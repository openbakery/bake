//
// Created by René Pirringer on 14.12.2025
//

open class LineParser {
	private let text: String
	private var currentIndex: String.Index
	private var previousIndex: String.Index

	public init(_ text: String) {
		self.text = text
		self.currentIndex = text.startIndex
		self.previousIndex = text.startIndex
	}

	open func nextLine() -> String? {
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

	open func hasMoreLines() -> Bool {
		return currentIndex < text.endIndex
	}

	open func reset() {
		currentIndex = text.startIndex
	}

	open func oneBack() {
		currentIndex = previousIndex
	}
}
