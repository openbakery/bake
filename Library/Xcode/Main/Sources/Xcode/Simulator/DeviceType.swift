//
// Created by René Pirringer on 13.12.2025
//


struct DeviceType {

	init?(_ line: String) {
		// iPad Pro (11-inch) (4th generation) (16GB) (com.apple.CoreSimulator.SimDeviceType.iPad-Pro-11-inch-4th-generation-16GB)
		guard let range = line.range(of: " (com") else {
			return nil
		}
		name = String(line[line.startIndex..<range.lowerBound])
		let startIndex = line.index(range.lowerBound, offsetBy: 2)
		let endIndex = line.index(line.endIndex, offsetBy: -1)
		identifier = String(line[startIndex..<endIndex])

	}

	let name: String
	let identifier: String
}
