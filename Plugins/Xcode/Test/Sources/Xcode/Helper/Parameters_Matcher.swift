//
// Created by René Pirringer on 30.1.2026
//

import Hamcrest

public func hasParameter(_ key: String, _ value: String) -> Matcher<[String]> {
	return Matcher("has parameter") { (parameters) -> MatchResult in

		guard let index = parameters.firstIndex(of: key) else {
			return .mismatch("Does not contain parameter \(key)")
		}
		if parameters.count < index + 1 {
			return .mismatch("Contains parameter \(key) but no value found")
		}
		if parameters[index + 1] != value {
			return .mismatch("Expected value \(value) but was \(parameters[index+1])")
		}
		return .match
	}
}
