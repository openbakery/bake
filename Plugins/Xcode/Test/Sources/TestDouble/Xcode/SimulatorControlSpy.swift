//
// Created by René Pirringer on 10.1.2026
//

import BakeXcode

class SimulatorControlSpy: SimulatorControl {


	public var listCalled = false

	override open func list() async throws {
		self.listCalled = true
	}

	public var deviceCalled = false
	public var deviceName: String?
	public var deviceVersion: String?
	public var deviceType: SDKType?
	public var deviceResult: Device?
	override open func device(name: String? = nil, version: String? = nil, type: SDKType = .iOS) async throws -> Device? {
		self.deviceCalled = true
		self.deviceName = name
		self.deviceVersion = version
		self.deviceType = type

		return deviceResult

	}
}
