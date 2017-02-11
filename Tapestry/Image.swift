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

    typealias Source = (data: Data, format: Format) -> CGImage?

    static var formatFileExtensions: [String: Format] =  ["jpeg": .jpeg, "jpg": .jpeg, "png": .png]
    static var formatSources: [Format: Source] = [.jpeg: imageFrom(_:format:), .png = imageFrom(_:format:)]

    /// Default supported image formats.
    enum Format: UInt8 {
        case jpeg
        case png
    }
    
    enum Error: Swift.Error {
        case unsupportedFormat
    }
    
    private var image: CGImage
    /// The image type.
    ///
    /// For formats supported by Tapestry, returns a Format enum raw value.
    /// For other formats, must return a custom constant higher than 128.
    let format: UInt8
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
    var colorSpace: ColorSpace {
        return ColorSpace(image.colorSpace)
    }
    var data: Data
    
    // MARK: - Initialization

    convenience init(url: URL) throws {
        guard let format = formatFileExtensions[url.pathExtension] else {
            throw Error.unsupportedImageFormat
        }
        return init(data: Data(url: url), format: format)
    }
    
    required init(data: Data, format: Format) throws {
        guard let image = formatSources[format](data, format: format) else {
            throw Error.unsupportedFormat
        }
        self.image = image
        self.data = data
        self.format = format
    }
    
    required init(size: Size) {
    
    }
    
    private required init(size: Size, bitsPerComponent: BitsPerComponent, bitsPerPixel: UIInt8, bytesPerRow: UIInt, info: CGBitmapInfo, provider: CGDataProvider) {
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
    
    // MARK: - JPEG and PNG Support
    
    func imageFrom(_ data: Data, format: Format) -> CGImage? {
        switch format {
        case jpeg:
            return (image: CGImage(jpegDataProviderSource: CGDataProvider(data), decode: nil, shouldInterpolate: true, intent: .default), data: data)
        case png:
            return init(image: CGImage(pngDataProviderSource: CGDataProvider(data), decode: nil, shouldInterpolate: true, intent: .default), data: data)
        default:
            return nil
        }
    }
}
