//
// Created by René Pirringer on 23.12.2025
//


public struct Dependency: CustomStringConvertible {

	public init(name: String, package: String) {
		self.name = name
		self.package = package
	}

	let name: String
	let package: String


	public var description: String {
		return ".product(name: \"\(name)\", package: \"\(package)\")"
	}
}
