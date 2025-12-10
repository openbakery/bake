
import Foundation

public extension Data {

	var utf8String: String? {
		String(data: self, encoding: .utf8)
	}

}
