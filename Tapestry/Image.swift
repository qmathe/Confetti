/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

enum BitsPerComponent: UInt8 {
    case 1
    case 2
    case 4
    case 8
    case 16
}

/// Bitmap image
///
/// The image data must be in a packed format, planar is unsupported.
///
/// To draw an image, use 2DContext.drawImage(:in:).
open struct Image {
    
    private var image: CGImage
    let size: Size {
        return Size(image.size.width, image.size.height)
    }
    /// The number of bits used to encode a color component.
    ///
    /// The represented color range increases with this value.
    var bitsPerComponent: BitsPerComponent
    /// The number of color components per pixel.
    ///
    /// For example, both CMYK (cyan, magenta, yellow, black) and RGBA (red, green, blue, alpha) use 4.
    var componentsPerPixel: UInt8 {
        return image.bitsPerPixel
    }
    var bytesPerRow: UInt {
        return image.bytesPerRow
    }
    var colorSpace: ColorSpace?
    var data: Data

    convenience init(url: URL) {
        return init(data: Data(url: url))
    }
    
    init(size: Size, data: Data, bitsPerComponent: BitsPerComponent, bitsPerPixel: UIInt8, bytesPerRow: UIInt) {
        return Image(size: size,
                 provider: CGDataProvider(data),
         bitsPerComponent: bitsPerComponent.rawValue,
             bitsPerPixel: bitsPerPixel,
              bytesPerRow: bytesPerRow)
    }
    
    private init(size: Size, provider: CGDataProvider, bitsPerComponent: BitsPerComponent, bitsPerPixel: UIInt8, bytesPerRow: UIInt) {
        let info = CGBitmapInfo()

        self.data = data
        self.image = CGImage(width: size.width,
                            height: size.height,
                  bitsPerComponent: bitsPerComponent.rawValue,
                      bitsPerPixel: bitsPerPixel,
                       bytesPerRow: bytesPerRow,
                             space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: info,
                          provider: provider,
                            decode: nil,
                 shouldInterpolate: true,
                            intent: .defaultIntent)
    }
}
