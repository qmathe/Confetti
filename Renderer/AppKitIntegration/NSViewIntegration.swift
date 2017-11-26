/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  November 2017
	License:  MIT
 */

import Foundation
import Tapestry

class ConfettiView: NSView {

    private weak var item: Item?
    
    // MARK: - Initialization
    
    required init(_ item: Item) {
        super.init(frame: CGRectFromRect(item.frame))
        self.item = item
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Routing Events
    
    override func mouseUp(with event: NSEvent) {
        guard let item = item,
              let state = item.controlState,
              let location = event.window?.point(from: event.locationInWindow) else {
            print("Missing item, state or window - \(event)")
            return
        }
        let touch = Touch(timestamp: event.timestamp, tapCount: UInt(event.clickCount), location: location, modifiers: [])
        state.touches.onNext([touch])
    }
}
