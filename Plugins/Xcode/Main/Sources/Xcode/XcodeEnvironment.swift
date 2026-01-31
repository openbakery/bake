//
// Created by René Pirringer on 31.1.2026
//

import Bake

public protocol XcodeEnvironment: CustomStringConvertible {
	var environment: [String: String] { get }
	var commandRunner: CommandRunner { get }
}
