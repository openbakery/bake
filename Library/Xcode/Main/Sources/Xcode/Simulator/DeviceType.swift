//
// Created by René Pirringer on 13.12.2025
//

import OBCoder

public struct DeviceType: Encodable {

	public init(name: String, identifier: String) {
		self.name = name
		self.identifier = identifier
	}

	public init?(decoder: OBCoder.Decoder) {
		guard let name = decoder.string(forKey: "name") else {
			return nil
		}
		guard let identifier = decoder.string(forKey: "identifier") else {
			return nil
		}
		self.init(name: name, identifier: identifier)
	}

	public func encode(with coder: Coder) {
		// only decode is supported
	}

	public let name: String
	public let identifier: String
}
