//
// Created by René Pirringer on 10.1.2026
//


public struct Destination: Sendable {

	public init(type: SDKType, identifier: String? = nil, architecture: Architecture? = nil, simulator: Bool = false) {
		self.type = type
		self.identifier = identifier
		self.architecture = architecture
		self.simulator = simulator
	}

	public let type: SDKType
	public let identifier: String?
	public let architecture: Architecture?
	public let simulator: Bool


	public var value: String {
		var tokens = [String]()
		if identifier == nil && type != .macOS {
			tokens.append("generic/")
		}
		tokens.append("platform=\(type.value(simulator: simulator))")
		if let identifier {
			tokens.append(",id=\(identifier)")
		}
		if let architecture {
			tokens.append(",arch=\(architecture.value)")
		}
		return tokens.joined(separator: "")
	}

	public static let iOSGeneric = Destination(type: .iOS)
	public static let macOS = Destination(type: .macOS, architecture: .arm64)

}
