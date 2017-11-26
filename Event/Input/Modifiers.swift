/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  November 2017
	License:  MIT
 */

import Foundation
import Tapestry

public struct Modifiers: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let command = Modifiers(rawValue: 1)
    public static let option = Modifiers(rawValue: 2)
    public static let control = Modifiers(rawValue: 4)
    public static let shift = Modifiers(rawValue: 8)
}
