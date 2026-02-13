//

import Foundation
import OBCoder

public protocol OutputHandler: Sendable {

	func process(line: String)

}

extension Array where Element == OutputHandler {
	func process(line: String) {
		self.forEach { $0.process(line: line) }
	}
}
