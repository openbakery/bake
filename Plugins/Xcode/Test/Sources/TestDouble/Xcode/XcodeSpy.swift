//
// Created by René Pirringer on 31.1.2026
//

import Bake
import BakeTestHelper
import BakeXcode

public struct XcodeSpy: Xcode {

	public init() {
		commandRunnerFake = CommandRunnerFake()
	}

	public var environment: [String: String] { [:] }
	public var commandRunner: CommandRunner { commandRunnerFake }
	public let commandRunnerFake: CommandRunnerFake

	public var description: String {
		"XcodeSpy"
	}
}
