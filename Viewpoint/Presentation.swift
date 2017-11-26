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
    func send<U>(_ value: U)
}

// MARK: - Handling Changes

public extension Presentation {

	public func update() -> [Presentation] {
		let descendantPresentations = presentations.flatMap { $0.update() }
		let presentation = changed ? [self] : []
		changed = false
		return presentation + descendantPresentations
	}
    
    // MARK: - Emitting Events
    
    public func send<U>(_ value: U) {
        item.eventCenter.send(value, from: self)
    }
}
