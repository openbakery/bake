//

import Foundation
import OBCoder

class OutputHandler {

	var data: Data?

	var hasData: Bool {
		if let data = self.data {
			return data.count > 0
		}
		return false
	}


	func handle(data: Data) {
		self.data = data
	}
}
