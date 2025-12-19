//
// Created by René Pirringer on 15.12.2025
//

import Foundation

extension Bundle {

	public func load(filename: String) throws -> String? {
		let url = URL(fileURLWithPath: filename)
		guard let basename = url.basename else { return nil }
		guard let type = url.fileExtension else { return nil }
		guard let fullPath = self.url(forResource: basename, withExtension: type) else { return nil }
		return try String(contentsOf: fullPath, encoding: .utf8)
	}

}
