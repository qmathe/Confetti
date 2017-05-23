/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

public struct Blend: Paint {
    
    enum Mode {
        case normal
        case multiply
        case screen
        case overlay
        case darken
        case lighten
        case colorDodge
        case colorBurn
        case softLight
        case hardLight
        case difference
        case exclusion
        case hue
        case saturation
        case color
        case luminosity
        case clear
        case copy
        case sourceIn
        case sourceOut
        case sourceAtop
        case destinationOver
        case destinationIn
        case destinationOut
        case destinationAtop
        case xor
        case plusDarker
        case plusLighter
    }

    let mode: Mode
    let alpha: VectorFloat
}
