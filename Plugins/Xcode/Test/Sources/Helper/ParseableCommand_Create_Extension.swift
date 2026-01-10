//
// Created by René Pirringer on 10.1.2026
//

import ArgumentParser
import Bake

extension ParsableCommand {

	static func create(_ arguments: [String] = []) throws -> Self {
		if let result = try Self.parseAsRoot(["iPhone"]) as? Self {
			return result
		}
		throw BakeError.illegalStateError("cannot create command")
	}


}
