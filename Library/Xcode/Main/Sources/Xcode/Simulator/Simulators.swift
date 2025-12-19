//
// Created by René Pirringer on 13.12.2025
//

import Bake

public struct Simulators {

	public init(deviceTypes: [DeviceType], runtimes: [Runtime], devices: Devices) {
		self.deviceTypes = deviceTypes
		self.runtimes = runtimes.sorted { $0.version > $1.version }
		self.devices = devices
	}

	let deviceTypes: [DeviceType]
	let runtimes: [Runtime]
	let devices: Devices


	public func runtime(type: SDKType = .iOS, version: Version? = nil) -> Runtime? {
		if let version {
			return runtimes.first { $0.type == type && $0.version == version }
		}
		return runtimes.first { $0.type == type }
	}

	public func runtime(device: Device) -> Runtime? {
		for runtime in runtimes {
			for currentDevice in devices(forRuntime: runtime) ?? [] where device == currentDevice {
				return runtime
			}
		}
		return nil
	}

	public func devices(forRuntime runtime: Runtime) -> [Device]? {
		return devices.get(runtime: runtime)
	}

	public func device(name: String? = nil, version: String) -> Device? {
		return self.device(name: name, version: Version(string: version))
	}

	public func device(name: String? = nil, version: Version? = nil) -> Device? {
		guard let runtime = runtime(version: version) else { return nil }
		guard let devices = devices(forRuntime: runtime) else { return nil }
		if let name {
			for device in devices where device.name.contains(name) {
				return device
			}
		}
		return devices.first

	}

}
