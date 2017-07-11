/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation

public protocol Presentation: class {
	var presentations: [Presentation] { get }
	var changed: Bool { get set }
	var item: Item { get }
	func update() -> [Presentation]
}

// MARK: - Handling Changes

public extension Presentation {

	public func update() -> [Presentation] {
		let descendantPresentations = presentations.flatMap { $0.update() }
		let presentation = changed ? [self] : []
		changed = false
		return presentation + descendantPresentations
	}
}
