//
// Created by René Pirringer on 13.12.2025
//

import Bake

public struct Simulators {

	public init(deviceTypes: [DeviceType], runtimes: [Runtime]) {
		self.deviceTypes = deviceTypes
		self.runtimes = runtimes.sorted { $0.version > $1.version }
	}

	let deviceTypes: [DeviceType]
	let runtimes: [Runtime]


	public func runtime(type: SDKType, version: Version? = nil) -> Runtime? {
		if let version {
			return runtimes.first { $0.type == type && $0.version == version }
		}
		return runtimes.first { $0.type == type }
	}

}
