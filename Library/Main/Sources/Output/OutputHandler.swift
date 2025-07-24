//

import Foundation
import OBCoder

public protocol OutputHandler: Sendable {

	func process(line: String) async

}

extension OutputHandler {
	public func message(_ string: String) {
		Task {
			await self.process(line: string)
		}
	}

}
