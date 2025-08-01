//
//  Wait.swift
//  Bake
//
//  Created by René Pirringer on 01.08.25.
//

import Foundation

@MainActor
public func wait<T:Sendable>(source: T, timeout: TimeInterval = 1.0, closure: @escaping (T) -> Bool) async {
	await withCheckedContinuation { continuation in
		Task {
			var count = 0
			while count < 10 {
				if closure(source) {
					break
				}

				try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * timeout))
				count += 1
			}
			continuation.resume()
		}
	}

}
