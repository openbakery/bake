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

	public init(name: String, package: String, plugin: Bool = false) {
		self.name = name
		self.package = package
		self.plugin = plugin
	}

	public init?(import line: String) {
		guard let data = Self.parse(line: line, string: Self.importString) else { return nil }
		self.init(name: data.name, package: data.package)
	}

	public init?(plugin line: String) {
		guard let data = Self.parse(line: line, string: Self.pluginString) else { return nil }
		self.init(name: data.name, package: data.package, plugin: true)
	}

	static func parse(line: String, string: String) -> (name: String, package: String)? {
		guard let startIndex = line.range(of: string) else { return nil }
		guard let endIndex = line.range(of: ")") else { return nil }

		let parameterString = line[startIndex.upperBound..<endIndex.lowerBound]

		let tokens = parameterString.split(separator: ",")
		guard tokens.count == 2 else { return nil }

		guard let packageIndex = tokens[1].range(of: "package:") else { return nil }
		let package = tokens[1][packageIndex.upperBound...]

		return (name: tokens[0].trimQuotes(), package: package.trimQuotes())
	}

	let name: String
	let package: String
	let plugin: Bool

	static let importString = "@import("
	static let pluginString = "@plugin("


	public var description: String {
		return ".product(name: \"\(name)\", package: \"\(package)\")"
	}
}
