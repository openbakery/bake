//

import Foundation
import OBCoder

public protocol OutputHandler: Sendable {

	@MainActor func process(line: String)


}

extension OutputHandler {
	public func message(_ string: String) {
		if Thread.isMainThread {
			MainActor.assumeIsolated {
				self.process(line: string)
				return
			}
		}
		Task { @MainActor in
			self.process(line: string)
		}
	}

}
