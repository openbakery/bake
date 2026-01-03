//
// Created by René Pirringer on 23.12.2025
//

import Foundation

extension StringProtocol {
	fileprivate func trimQuotes() -> String {
		let characterSet = CharacterSet(charactersIn: "\"").union(.whitespaces)
		return self.trimmingCharacters(in: characterSet)
	}
}


public struct Dependency: CustomStringConvertible, Sendable {

	public init(name: String, package: String) {
		self.name = name
		self.package = package
	}

	public init?(line: String) {
		guard let startIndex = line.range(of: "@import(") else { return nil }
		guard let endIndex = line.range(of: ")") else { return nil }

		let parameterString = line[startIndex.upperBound..<endIndex.lowerBound]

		let tokens = parameterString.split(separator: ",")
		guard tokens.count == 2 else { return nil }

		guard let packageIndex = tokens[1].range(of: "package:") else { return nil }
		let package = tokens[1][packageIndex.upperBound...]

		self.init(name: tokens[0].trimQuotes(), package: package.trimQuotes())
	}

	let name: String
	let package: String


	public var description: String {
		return ".product(name: \"\(name)\", package: \"\(package)\")"
	}
}
