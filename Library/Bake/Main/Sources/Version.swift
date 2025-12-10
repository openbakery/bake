//
// Created by René Pirringer on 29.10.2025
//

import Foundation

open class Version: Comparable, CustomStringConvertible {

	public let major: Int
	public let minor: Int
	public let maintenance: Int
	public let build: Int

	public init(major: Int = 0, minor: Int = 0, maintenance: Int = 0, build: Int = 0) {
		self.major = major
		self.minor = minor
		self.maintenance = maintenance
		self.build = build
	}

	public convenience init(string: String) {
		let tokens = string.components(separatedBy: CharacterSet(charactersIn: ". "))
		var major = 0
		var minor = 0
		var maintenance = 0
		var build = 0
		for (index, token) in tokens.enumerated() {
			if let intValue = Int(token) {
				switch index {
				case 0:
					major = intValue
				case 1:
					minor = intValue
				case 2:
					maintenance = intValue
				case 3:
					build = intValue
				default:
					break
				}
			}
		}
		self.init(major: major, minor: minor, maintenance: maintenance, build: build)
	}


	open var description: String {
		var result = "\(major).\(minor)"

		if build > 0 {
			result += ".\(maintenance).\(build)"
		} else if maintenance > 0 {
			result += ".\(maintenance)"
		}
		return result
	}


	public static func == (lhs: Version, rhs: Version) -> Bool {
		return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.maintenance == rhs.maintenance && lhs.build == rhs.build
	}

	public static func < (lhs: Version, rhs: Version) -> Bool {
		if lhs.major < rhs.major {
			return true
		}
		if lhs.major == rhs.major && lhs.minor < rhs.minor {
			return true
		}
		if lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.maintenance < rhs.maintenance {
			return true
		}
		if lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.maintenance == rhs.maintenance && lhs.build < rhs.build {
			return true
		}
		return false
	}
}
