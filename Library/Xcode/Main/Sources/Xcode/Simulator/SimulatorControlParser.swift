//
// Created by René Pirringer on 12.12.2025
//

import Bake
import OBCoder
import Foundation

open class SimulatorControlParser {

	public init() {
	}

	open func parseJson(_ contents: String) -> Simulators? {
		let decoder = JSONDecoder(jsonString: contents)

		guard let deviceTypes = decoder.decodeArray(forKey: "devicetypes", type: DeviceType.self) else { return nil }
		guard let runtimes = decoder.decodeArray(forKey: "runtimes", type: Runtime.self) else { return nil }

		return Simulators(deviceTypes: deviceTypes, runtimes: runtimes)
	}

}
