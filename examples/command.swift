#!/usr/bin/swift sh
import Bake
import BakeXcode  // openbakery/Bake == develop
import Foundation

Log.level = .debug
Log.instance.showLevel = true
Log.debug("debug")

let commandRunner = await CommandRunner()
let outputHandler = StringOutputHandler()
do {
	try await commandRunner.runWithResult("/usr/bin/xcrun", "simctl", "list", "--json", outputHandler: outputHandler)
} catch {
	// ignore
}

print("\(outputHandler.lines.joined(separator: "\n"))")
