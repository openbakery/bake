//
// Created by René Pirringer on 15.12.2025
//

public enum SDKType {
	case iOS, macOS, tvOS, watchOS, visionOS


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
