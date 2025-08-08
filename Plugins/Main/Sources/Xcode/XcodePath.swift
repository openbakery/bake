//
// Created by René Pirringer on 11.7.2025
//

import Foundation
import OBExtra

public struct XcodePath: Sendable {

	public init(base: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) throws {
		self.baseDirectory = base
		try prepare()
	}

	let baseDirectory: URL
	public var buildDirectory: URL { baseDirectory.appendingPathComponent("build") }
	public var symbolDirectory: URL { buildDirectory.appendingPathComponent("sym") }
	public var destinationDirectory: URL { buildDirectory.appendingPathComponent("dst") }
	public var objectDirectory: URL { buildDirectory.appendingPathComponent("obj") }
	public var sharedPrecompiledHeadersDirectory: URL { buildDirectory.appendingPathComponent("shared") }
	public var codesignPath: URL? {
		do {
			let result = buildDirectory.appendingPathComponent("codesign")
			try result.createDirectories()
			return result
		} catch {
			// nil is returned
		}
		return nil
	}

	public func prepare() throws {
		try symbolDirectory.createDirectories()
		try destinationDirectory.createDirectories()
		try objectDirectory.createDirectories()
		try sharedPrecompiledHeadersDirectory.createDirectories()
	}

}

/*

I leave the comment for because I have played in a swift script a bit with codesigning.
This is not implemented yet, but when it is this maybe could be useful.

struct BuildInfo {


	var appPath: URL {
		sym.appendingPathComponent("Debug-iphoneos/Example.app")
	}

	var appInfoPlist: URL {
		appPath.appendingPathComponent("Info.plist")
	}


	var appProvisioningProfile: URL {
		appPath.appendingPathComponent("embedded.mobileprovision")
	}

	func frameworks() async throws -> [URL] {
		return try await filter(url: appPath.appendingPathComponent("Frameworks"), name: ".framework")
	}

	func plugins() async throws -> [URL] {
		return try await filter(url: appPath.appendingPathComponent("Plugins"), name: ".appex")
	}

	func filter(url: URL, name: String) async throws -> [URL] {
		var result = [URL]()

		if let enumerator = FileManager.default.enumerator(
			at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants])
		{
			for case let fileURL as URL in enumerator {
				let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
				if fileURL.path.hasSuffix(name) {
					result.append(fileURL)
				}
			}

			// sym.appendingPathComponent("Debug-iphoneos/Example.app")
		}
		return result
	}

}
*/
