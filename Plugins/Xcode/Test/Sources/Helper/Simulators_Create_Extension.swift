//
// Created by René Pirringer on 10.1.2026
//

import Foundation

@testable import BakeXcode

extension Simulators {

	static func create() -> Simulators? {
		do {
			if let contents = try Bundle.module.load(filename: "simctl.json") {
				let parser = SimulatorControlParser()
				return parser.parseListJson(contents)
			}
		} catch {
			// ignore, return nil
		}
		return nil
	}

}
