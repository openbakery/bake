//
// Created by René Pirringer on 13.12.2025
//

import Bake

struct Runtime {

	public init?(_ string: String) {

		guard let match = string.firstMatch(of: pattern) else { return nil }

		name = "\(match.1) \(match.2)"
		identifier = String(match.5)

		version = Version(string: String(match.3)).update(build: String(match.4))


	}

	let pattern = #/(\w+)\s(\d+\.\d+)\s\((\d+\.\d+)\s-\s(\w+)\)\s-\s(.*)/#

	let identifier: String
	let name: String
	let version: Version

}
