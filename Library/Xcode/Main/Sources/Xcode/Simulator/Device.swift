//
// Created by René Pirringer on 19.12.2025
//


import Bake
import Foundation
import OBCoder

public struct Device: Encodable {

	public init(
		identifier: String,
		name: String,
		dataPath: String,
		deviceTypeIdentifier: String,
		isAvailable: Bool,
		state: String
	) {
		self.identifier = identifier
		self.name = name
		self.isAvailable = isAvailable
		self.deviceTypeIdentifier = deviceTypeIdentifier
		self.dataPath = dataPath
		self.state = state
	}

	public init?(decoder: OBCoder.Decoder) {
		guard let name = decoder.string(forKey: "name") else { return nil }
		guard let identifier = decoder.string(forKey: "udid") else { return nil }
		guard let isAvailable = decoder.bool(forKey: "isAvailable") else { return nil }
		guard let deviceTypeIdentifier = decoder.string(forKey: "deviceTypeIdentifier") else { return nil }
		guard let dataPath = decoder.string(forKey: "dataPath") else { return nil }
		guard let state = decoder.string(forKey: "state") else { return nil }

		self.init(
			identifier: identifier,
			name: name,
			dataPath: dataPath,
			deviceTypeIdentifier: deviceTypeIdentifier,
			isAvailable: isAvailable,
			state: state
		)


	}

	let identifier: String
	let name: String
	let isAvailable: Bool
	let deviceTypeIdentifier: String
	let dataPath: String
	let state: String

	public func encode(with coder: Coder) {
		// only decode is supported
	}
}
