//
// Created by René Pirringer on 29.10.2025
//

import Foundation

open class Version: Comparable, CustomStringConvertible {

	public let major: Int
	public let minor: Int?
	public let maintenance: Int?
	public let build: String?

	public init(major: Int = 0, minor: Int? = nil, maintenance: Int? = nil, build: String? = nil) {
		self.major = major
		self.minor = minor
		self.maintenance = maintenance
		self.build = build
	}

	public convenience init(string: String, build: String? = nil) {
		let tokens = string.components(separatedBy: CharacterSet(charactersIn: ". "))
		var major = 0
		var minor: Int?
		var maintenance: Int?
		var buildString = build
		for (index, token) in tokens.enumerated() {
			switch index {
			case 0:
				major = Int(token) ?? 0
			case 1:
				minor = Int(token)
			case 2:
				maintenance = Int(token)
			case 3:
				buildString = token
			default:
				break
			}
		}
		self.init(major: major, minor: minor, maintenance: maintenance, build: buildString)
	}


	open var description: String {
		var result = "\(major)"

		if let minor {
			result += ".\(minor)"
		}
		if let maintenance {
			result += ".\(maintenance)"
		}
		return result
	}

	open var fullVersionString: String {
		var result = "\(description)"

		if let build {
			result += " - (\(build))"
		}
		return result
	}


	public static func == (lhs: Version, rhs: Version) -> Bool {
		if let lhsBuild = lhs.build, let rhsBuild = rhs.build {
			return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.maintenance == rhs.maintenance && lhsBuild == rhsBuild
		}
		return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.maintenance == rhs.maintenance
	}


	public static func < (lhs: Version, rhs: Version) -> Bool {
		if lhs.major < rhs.major {
			return true
		}

		if lhs.major == rhs.major && (lhs.minor ?? 0) < (rhs.minor ?? 0) {
			return true
		}
		if lhs.major == rhs.major && lhs.minor == rhs.minor && (lhs.maintenance ?? 0) < (rhs.maintenance ?? 0) {
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
