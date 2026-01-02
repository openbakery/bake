//
// Created by René Pirringer on 15.12.2025
//

import Foundation
import OBExtra

extension Bundle {

	public func url(filename: String) throws -> URL? {
		let url = URL(fileURLWithPath: filename)
		guard let basename = url.basename else { return nil }
		guard let type = url.fileExtension else { return nil }
		return self.url(forResource: basename, withExtension: type)
	}

	public func load(filename: String) throws -> String? {
		guard let fullPath = try self.url(filename: filename) else { return nil }
		return try String(contentsOf: fullPath, encoding: .utf8)
	}

}
