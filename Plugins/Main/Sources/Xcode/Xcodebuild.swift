//
// Created by René Pirringer on 8.8.2025
//


public struct Xcodebuild: Sendable {

	public init(path: XcodePath) {
		self.path = path
	}

	let path: XcodePath
}
