//
// Created by René Pirringer on 23.12.2025
//

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

	func build() -> String {
		let dependenciesString = self.dependencies?.compactMap({ $0.description }).joined(separator: ",\n\t\t\t\t")
		return packageString.replacingOccurrences(of: "{{DEPENDENCIES}}", with: dependenciesString ?? "")
	}
}
