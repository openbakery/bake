#!/usr/bin/swift sh
import Bake
import BakeXcode  // openbakery/Bake == main
import Foundation

Log.level = .debug
Log.instance.showLevel = true
Log.debug("debug")

let commandRunner = await CommandRunner()
let outputHandler = StringOutputHandler()
do {
	await try commandRunner.run("/bin/ls", arguments: ["-la"], outputHandler: outputHandler)
} catch {
	// ignore
}

print("\(outputHandler.lines.joined(separator: "\n"))")
