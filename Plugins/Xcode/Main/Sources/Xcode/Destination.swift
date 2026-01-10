//
// Created by René Pirringer on 10.1.2026
//


public struct Destination: Sendable {

	public let platform: String
	public let identifier: String?
	public let architecture: Architecture?

	public init(type: SDKType, identifier: String? = nil, architecture: Architecture? = nil) {
		self.platform = type.value
		self.identifier = identifier
		self.architecture = architecture
	}

	public var value: String {
		var result = ""
		if identifier == nil {
			result += "generic/"
		}
		result += "platform=\(platform)"
		if let identifier {
			result += ",id=\(identifier)"
		}
		if let architecture {
			result += ",arch=\(architecture.value)"
		}
		return result
	}

	public static let iOSGeneric = Destination(type: .iOS)
}
