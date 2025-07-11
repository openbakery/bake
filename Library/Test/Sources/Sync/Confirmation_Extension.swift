//
//  Confirmation_Extension.swift
//  Bake
//
//  Created by René Pirringer on 11.07.25.
//
import Testing

public extension Confirmation {


	static func waitForValue<T>(source: T, timeout: Double = 5, confirmation: (Testing.Confirmation), fulfillmentClosure: @escaping (T) -> Bool) -> _Concurrency.Task<Bool, Never> {
		let timeoutInMilliseconds = UInt64(timeout * 1000)
		let intervalInMilliseconds = UInt64(50)

		return _Concurrency.Task {
			var millisecondsPassed = UInt64(0)
			while millisecondsPassed < timeoutInMilliseconds {
				if fulfillmentClosure(source) {
					confirmation()
					return true
				}

				do {
					if #available(iOS 16, *) {
						try await _Concurrency.Task.sleep(for: .milliseconds(intervalInMilliseconds))
					} else {
						try await _Concurrency.Task.sleep(nanoseconds: intervalInMilliseconds * 100_000)
					}
				} catch {
					return false
				}
				millisecondsPassed += intervalInMilliseconds
			}
			return false
		}

	}


	@discardableResult
	static func wait(_ task: _Concurrency.Task<Bool, Never>) async -> Swift.Result<Bool, Never> {
		return await task.result
	}

	static func waitForValue(timeout: Double = 10, confirmation: (Testing.Confirmation), fulfillmentClosure: @escaping () -> Bool) -> _Concurrency.Task<Bool, Never> {
		self.waitForValue(source: "", timeout: timeout, confirmation: confirmation) { _ in
			fulfillmentClosure()
		}
	}

	static func wait(fulfillmentClosure: @escaping () -> Bool) async {
		if fulfillmentClosure() {
			return
		}
		await confirmation("called") { confirmation in
			let task = Confirmation.waitForValue(confirmation: confirmation, fulfillmentClosure: fulfillmentClosure)
			await Confirmation.wait(task)
		}
	}

	static func wait<T>(_ source: T, fulfillmentClosure: @escaping (T) -> Bool) async {
		if fulfillmentClosure(source) {
			return
		}
		await confirmation("called") { confirmation in
			let task = Confirmation.waitForValue(source: source, confirmation: confirmation, fulfillmentClosure: fulfillmentClosure)
			await Confirmation.wait(task)
		}
	}

	static func wait<T>(source: T, fulfillmentClosure: @escaping (T) -> Bool) async {
		if fulfillmentClosure(source) {
			return
		}
		await confirmation("called") { confirmation in
			let task = Confirmation.waitForValue(source: source, confirmation: confirmation, fulfillmentClosure: fulfillmentClosure)
			await Confirmation.wait(task)
		}
	}

	static func wait<T, S>(fulfillmentSource: T, actionSource: S, fulfillmentClosure: @escaping (T) -> Bool, actionClosure: @escaping (S) -> Void) async {
		if fulfillmentClosure(fulfillmentSource) {
			return
		}
		await confirmation("called") { confirmation in
			let task = Confirmation.waitForValue(source: fulfillmentSource, confirmation: confirmation, fulfillmentClosure: fulfillmentClosure)
			actionClosure(actionSource)
			await Confirmation.wait(task)
		}
	}

	static func wait(fulfillmentClosure: @escaping () -> Bool, actionClosure: @escaping () -> Void) async {
		if fulfillmentClosure() {
			return
		}
		await confirmation("called") { confirmation in
			let task = Confirmation.waitForValue(confirmation: confirmation, fulfillmentClosure: fulfillmentClosure)
			actionClosure()
			await Confirmation.wait(task)
		}
	}
}

