//
// Created by René Pirringer on 30.1.2026
//

public enum Codesigning: Equatable {
	case none
	case identity(String)
	case automatic

	public var parameters: [String] {
		switch self {
		case .none:
			return [
				"CODE_SIGN_IDENTITY=",
				"CODE_SIGNING_REQUIRED=NO",
				"CODE_SIGNING_ALLOWED=NO"
			]
		case .identity(let name):
			return ["CODE_SIGN_IDENTITY=\(name)"]
		default:
			return ["-allowProvisioningUpdates"]
		}
	}
}
