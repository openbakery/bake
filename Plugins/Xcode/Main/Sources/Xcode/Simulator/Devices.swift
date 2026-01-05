//
// Created by René Pirringer on 19.12.2025
//

import Bake
import Foundation
import OBCoder

public struct Devices: Encodable {

	public init(data: [String: [Device]]) {
		self.data = data
	}

	public init?(decoder: OBCoder.Decoder) {

		var data = [String: [Device]]()
		for key in decoder.keys {
			if let array = decoder.decodeArray(forKey: key, type: Device.self) {
				data[key] = array
			}
		}

		// guard let name = decoder.string(forKey: "name") else { return nil }
		// guard let identifier = decoder.string(forKey: "identifier") else { return nil }
		// guard let versionNumber = decoder.string(forKey: "version") else { return nil }
		// guard let build = decoder.string(forKey: "buildversion") else { return nil }
		// let version = Version(string: versionNumber, build: build)

		self.init(data: data)
	}

	public func encode(with coder: Coder) {
		// only decode is supported
	}

	private let data: [String: [Device]]


	public func get(runtime: Runtime) -> [Device]? {
		return data[runtime.identifier]
	}

}
