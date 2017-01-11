/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

/// Bitmap image
///
/// To draw an image, use 2DContext.drawImage(:in:).
open struct Image {
    
    private var image: CGImage
    var size: Size
    var bitsPerComponent: Int
    var bitsPerPixel: Int
    var bytesPerRow: Int
    var colorSpace: ColorSpace?
    var data: Data

    convenience init(url: URL) {
        return init(data: Data(url: url))
    }
    
    init(data: Data) {
    
    }
}
