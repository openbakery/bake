//
// Created by René Pirringer on 12.12.2025
//

import Bake

open class SimulatorControlParser {

	public init() {
	}

	enum Mode {
		case deviceType, runtime, none
	}

	var mode = Mode.none

	// use the text representation for simctl -list because with Xcode 26.0 the json does not contain all data
	open func parse(_ contents: String) -> Simulators? {

		let lineParser = LineParser(contents)

		var deviceTypes = [DeviceType]()
		var runtimes = [Runtime]()


		while let line = lineParser.nextLine() {

			switch mode {
			case .none:
				if line == "== Device Types ==" {
					mode = .deviceType
				}
				if line == "== Runtimes ==" {
					mode = .runtime
				}
				print("line - \(line)")
			case .deviceType:
				if let type = DeviceType(line) {
					deviceTypes.append(type)
				} else {
					mode = .none
					lineParser.oneBack()
				}
			case .runtime:
				print("mode: runtime")
				if let runtime = Runtime(line) {
					runtimes.append(runtime)
				} else {
					mode = .none
					lineParser.oneBack()
				}
			}

		}

		return Simulators(deviceTypes: deviceTypes, runtimes: runtimes)

	}



}
