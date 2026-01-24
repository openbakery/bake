//
// Created by René Pirringer on 24.1.2026
//

public struct TestValue: Sendable {
	public let intValue: Int
	public let intValue1: Int
	public let intValue2: Int
	public let intValue3: Int
	public let boolValue: Bool
	public let boolValue1: Bool
	public let boolValue2: Bool
	public let boolValue3: Bool
	public let stringValue: String
	public let stringValue1: String
	public let stringValue2: String
	public let stringValue3: String

	init(
		intValue: Int = 0,
		intValue1: Int = 1,
		intValue2: Int = 2,
		intValue3: Int = 3,
		boolValue: Bool = false,
		boolValue1: Bool = true,
		boolValue2: Bool = false,
		boolValue3: Bool = true,
		stringValue: String = "Test",
		stringValue1: String = "first",
		stringValue2: String = "second",
		stringValue3: String = "thrid"
	) {
		self.intValue = intValue
		self.intValue1 = intValue1
		self.intValue2 = intValue2
		self.intValue3 = intValue3
		self.boolValue = boolValue
		self.boolValue1 = boolValue1
		self.boolValue2 = boolValue2
		self.boolValue3 = boolValue3
		self.stringValue = stringValue
		self.stringValue1 = stringValue1
		self.stringValue2 = stringValue2
		self.stringValue3 = stringValue3
	}

	public static var random: TestValue {
		self.random()
	}

	public static func random(boolValue: Bool = Bool.random()) -> TestValue {
		return TestValue(
			intValue: Int.random(in: 0...999999),
			intValue1: Int.random(in: 0...999999),
			intValue2: Int.random(in: 0...999999),
			intValue3: Int.random(in: 0...999999),
			boolValue: Bool.random(),
			boolValue1: Bool.random(),
			boolValue2: Bool.random(),
			boolValue3: Bool.random(),
			stringValue: Self.randomString,
			stringValue1: Self.randomString,
			stringValue2: Self.randomString,
			stringValue3: Self.randomString)
	}


	public static var randomValues: [TestValue] {
		var result = [TestValue]()
		for _ in 0...10 {
			result.append(TestValue.random)
		}
		return result
	}


	public static var randomValue: [TestValue] {
		return [TestValue.random]
	}

	public static var booleanValue: [TestValue] {
		return [TestValue.random(boolValue: true), TestValue.random(boolValue: false)]
	}


	static var randomString: String {
		let index = Int.random(in: 0..<stringValues.count)
		if index < stringValues.count {
			return stringValues[index]
		}
		return "Lorem"
	}

	static let stringValues = [
		"Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit", "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore", "magna", "aliqua"
	]

}
