//
// Created by René Pirringer on 29.10.2025
//

import Foundation

open class Version: Comparable, CustomStringConvertible {

	public let major: Int
	public let minor: Int
	public let maintenance: Int
	public let build: String

	public init(major: Int = 0, minor: Int = 0, maintenance: Int = 0, build: String = "") {
		self.major = major
		self.minor = minor
		self.maintenance = maintenance
		self.build = build
	}

	public convenience init(string: String, build: String = "") {
		let tokens = string.components(separatedBy: CharacterSet(charactersIn: ". "))
		var major = 0
		var minor = 0
		var maintenance = 0
		var buildString = build
		for (index, token) in tokens.enumerated() {
			switch index {
			case 0:
				major = Int(token) ?? 0
			case 1:
				minor = Int(token) ?? 0
			case 2:
				maintenance = Int(token) ?? 0
			case 3:
				buildString = token
			default:
				break
			}
		}
		self.init(major: major, minor: minor, maintenance: maintenance, build: buildString)
	}


	open var description: String {
		var result = "\(major).\(minor)"

		if build != "" {
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
		return false
	}


	open func update(major: Int? = nil, minor: Int? = nil, maintenance: Int? = nil, build: String? = nil) -> Version {
		return Version(
			major: major ?? self.major,
			minor: minor ?? self.minor,
			maintenance: maintenance ?? self.maintenance,
			build: build ?? self.build)
	}

}
