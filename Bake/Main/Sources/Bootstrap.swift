//
// Created by René Pirringer on 23.12.2025
//

import Bake
import Foundation

public enum LoadingError: Error {
	case resourceMissing(String)
}

struct Bootstrap {

	init() throws {
		if let packageString = try Bundle.module.load(filename: "Package.template") {
			self.packageString = packageString
		} else {
			throw LoadingError.resourceMissing("Cannot load Package.template")
		}
	}

	let packageString: String
	var dependencies: [Dependency]?

	mutating func add(dependencies: [Dependency]) {
		self.dependencies = dependencies
	}

	func createPackageSwift() -> String {
		let dependenciesString = self.dependencies?.compactMap({ $0.description }).joined(separator: ",\n\t\t\t\t")
		return packageString.replacingOccurrences(of: "{{DEPENDENCIES}}", with: dependenciesString ?? "")
	}

	var mainSwift = [String]()
	func createMainSwift() -> String {
		return mainSwift.joined(separator: "\n")
	}

	mutating func load(config: URL) throws {
		let contents = try String(contentsOf: config, encoding: .utf8)

		let parser = LineParser(contents)

		var dependencies = [Dependency]()
		while let line = parser.nextLine() {

			if line.hasPrefix("@import") {
				if let dependency = Dependency(line: line) {
					dependencies.append(dependency)
					mainSwift.append("import \(dependency.name)")
				}
			} else {
				mainSwift.append(line)
			}
		}

		self.add(dependencies: dependencies)
	}
}
