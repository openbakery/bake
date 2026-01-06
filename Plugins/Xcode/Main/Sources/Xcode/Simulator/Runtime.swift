//
// Created by René Pirringer on 13.12.2025
//

import Bake
import OBCoder

public struct Runtime: Encodable, CustomStringConvertible {

	public init(identifier: String, name: String, version: Version, type: SDKType) {
		self.identifier = identifier
		self.name = name
		self.version = version
		self.type = type
	}

	public init?(decoder: OBCoder.Decoder) {
		guard let name = decoder.string(forKey: "name") else { return nil }
		guard let identifier = decoder.string(forKey: "identifier") else { return nil }
		guard let versionNumber = decoder.string(forKey: "version") else { return nil }
		guard let build = decoder.string(forKey: "buildversion") else { return nil }
		guard let platform = decoder.string(forKey: "platform") else { return nil }

		let type = SDKType.value(platform)

		let version = Version(string: versionNumber, build: build)

		self.init(identifier: identifier, name: name, version: version, type: type)
	}

	public func encode(with coder: Coder) {
		// only decode is supported
	}

	public var description: String {
		return "Runtime(name: \(name), version: \(version))"
	}


	public let identifier: String
	public let name: String
	public let version: Version
	public let type: SDKType

}
