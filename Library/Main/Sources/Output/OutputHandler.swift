//

import Foundation
import OBCoder

public protocol OutputHandler: Sendable {

	func process(line: String)

}
