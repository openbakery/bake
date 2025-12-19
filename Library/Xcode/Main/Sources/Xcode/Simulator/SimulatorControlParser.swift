//
// Created by René Pirringer on 12.12.2025
//

import Bake
import Foundation
import OBCoder

open class SimulatorControlParser {

	public init() {
	}

	public func parseListJson(_ contents: String) -> Simulators? {
		let decoder = JSONDecoder(jsonString: contents)

		guard let deviceTypes = decoder.decodeArray(forKey: "devicetypes", type: DeviceType.self) else { return nil }
		guard let runtimes = decoder.decodeArray(forKey: "runtimes", type: Runtime.self) else { return nil }
		guard let devices = decoder.decode(forKey: "devices", type: Devices.self) else { return nil }

		return Simulators(deviceTypes: deviceTypes, runtimes: runtimes, devices: devices)
	}

}
