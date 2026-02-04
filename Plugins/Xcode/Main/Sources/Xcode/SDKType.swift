//
// Created by René Pirringer on 15.12.2025
//

public enum SDKType: Sendable {
	case iOS, macOS, tvOS, watchOS, visionOS

	func value(simulator: Bool = false) -> String {
		let suffix = simulator ? " Simulator" : ""
		switch self {
		case .iOS: return "iOS" + suffix
		case .macOS: return "macOS"
		case .tvOS: return "tvOS" + suffix
		case .watchOS: return "watchOS" + suffix
		case .visionOS: return "visionOS" + suffix
		}
	}

	var genericDestination: Destination { Destination(type: self) }


	static func value(_ string: String) -> SDKType {
		switch string.lowercased() {
		case "ios": return .iOS
		case "macos": return .macOS
		case "tvos": return .tvOS
		case "watchos": return .watchOS
		case "visionos": return .visionOS
		default:
			return .iOS
		}
	}

}
