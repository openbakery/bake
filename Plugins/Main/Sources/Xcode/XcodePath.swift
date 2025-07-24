//
// Created by René Pirringer on 11.7.2025
//

import Foundation
import OBExtra

public struct XcodePath {

	init(base: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) {
		self.baseDirectory = base
	}

	let baseDirectory: URL
	var buildDirectory: URL { baseDirectory.appendingPathComponent("build") }
	var symbolDirectory: URL { buildDirectory.appendingPathComponent("sym") }
	var destinationDirectory: URL { buildDirectory.appendingPathComponent("dst") }
	var objectDirectory: URL { buildDirectory.appendingPathComponent("obj") }
	var sharedPrecompiledHeadersDirectory: URL { buildDirectory.appendingPathComponent("shared") }

	public func prepare() {
		do {
			try symbolDirectory.createDirectories()
			try destinationDirectory.createDirectories()
			try objectDirectory.createDirectories()
			try sharedPrecompiledHeadersDirectory.createDirectories()
		} catch {
		}

	}
}

/*
struct BuildInfo {

	let buildDirectory: URL
	let dst: URL
	let obj: URL
	let sym: URL
	let sharedPrecomps: URL

	init(base: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) throws {

		buildDirectory = base.appendingPathComponent("build")
		dst = buildDirectory.appendingPathComponent("dst")
		obj = buildDirectory.appendingPathComponent("obj")
		sym = buildDirectory.appendingPathComponent("sym")
		sharedPrecomps = buildDirectory.appendingPathComponent("shared")

		try dst.mkdirs()
		try obj.mkdirs()
		try sym.mkdirs()
		try sharedPrecomps.mkdirs()
	}

	var codesignPath: URL {
		let result = buildDirectory.appendingPathComponent("codesign")
		result.mkdirs()
		return result
	}

	let keychainName = "_signing.keychain"

	var keychain: URL {
		codesignPath.appendingPathComponent(keychainName)
	}

	var appPath: URL {
		sym.appendingPathComponent("Debug-iphoneos/ELO.app")
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

			// sym.appendingPathComponent("Debug-iphoneos/ELO.app")
		}
		return result


	}

}
*/
