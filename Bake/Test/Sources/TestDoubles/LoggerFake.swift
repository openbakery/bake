
import BakeCLI

open class LoggerFake: Logger {

	var messages = [String]()


	override open func message(_ message: String) {
		messages.append(message)
	}
}
