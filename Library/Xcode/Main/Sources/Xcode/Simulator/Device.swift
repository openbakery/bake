//
// Created by René Pirringer on 19.12.2025
//


import Bake
import Foundation
import OBCoder

public struct Device: Encodable {

	public init() {
	}

	public init?(decoder: OBCoder.Decoder) {
		self.init()
	}

	public func encode(with coder: Coder) {
		// only decode is supported
	}
}
