/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  November 2017
	License:  MIT
 */

import Foundation
import Tapestry

public struct Touch {
    /// The time at which the touch finished.
    public let timestamp: TimeInterval
    /// A correlation marker to estimate whether new touches are updates to the current touch or not.
    public let marker: Int
    /// The number of repeated mouse clicks or finger taps within the sampling interval.
    ///
    /// Can be used to distinguish between single, double and triple clicks or taps.
    public let tapCount: UInt
    /// The location where the touch finished in the window coordinate space (with a top left origin).
    public let location: Point
    public let modifiers: Modifiers
    
    public func location(in item: Item) -> Point? {
        return item.convert(location, from: item.root)
    }
}
