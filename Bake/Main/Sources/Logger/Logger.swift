//
// Created by René Pirringer.
// Copyright (c) 2025 openbakery.org. All rights reserved.
//

open class Logger: Decodable {

	public init() {
	}

	open func message(_ message: String) {
		print(message)
	}

}
