//
// Created by René Pirringer on 11.7.2025
//

import Hamcrest
import Testing

class HamcrestReporter {

	public static func enable() {
		Hamcrest.SwiftTestingHamcrestReportFunction = { message, fileID, file, line, column in
			let location = Testing.SourceLocation(fileID: fileID, filePath: "\(file)", line: Int(line), column: Int(column))
			Issue.record(Testing.Comment(rawValue: message), sourceLocation: location)
		}
	}

}
