/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

/// A power of two value between 1 and 16.
public typealias BitsPerComponent = UInt8

public struct ColorSpace {

    public init(colorSpace: CGColorSpace?) {
    
    }
}

/// Bitmap image
///
/// The image data must be in a packed format, planar is unsupported.
///
/// To draw an image, use Context2D.drawImage(:in:).
public struct Image {

    typealias Source = (_ data: Data, _ format: Format) -> CGImage?

    static var formatFileExtensions: [String: Format] =  ["jpeg": .jpeg, "jpg": .jpeg, "png": .png]
    static var formatSources: [Format: Source] = [.jpeg: imageFrom(_:format:), .png: imageFrom(_:format:)]

    /// Default supported image formats.
    public enum Format: UInt8 {
        case jpeg
        case png
    }
    
    public enum Error: Swift.Error {
        case unsupportedFormat
        case unreadableContent
        case creationFailure
    }
    
    private var image: CGImage
    /// The image type.
    ///
    /// For formats supported by Tapestry, returns a Format enum raw value.
    /// For other formats, must return a custom constant higher than 128.
    /// For an unknown format, returns UInt8.max.
    public let format: UInt8
    public var size: Size {
        return Size(x: VectorFloat(image.width), y: VectorFloat(image.height), z: 0)
    }
    /// The number of bits used to encode a color component.
    ///
    /// The represented color range increases with this value.
    public var bitsPerComponent: BitsPerComponent {
        return UInt8(image.bitsPerComponent)
    }
    /// The number of color components per pixel.
    ///
    /// For example, both CMYK (cyan, magenta, yellow, black) and RGBA (red, green, blue, alpha) use 4.
    public var componentsPerPixel: UInt8 {
        return UInt8(image.bitsPerPixel)
    }
    public var bytesPerRow: UInt {
        return UInt(image.bytesPerRow)
    }
    public var colorSpace: ColorSpace {
        return ColorSpace(colorSpace: image.colorSpace)
    }
    public var data: Data
    
    // MARK: - Initialization

    public init(url: URL) throws {
        guard let format = Image.formatFileExtensions[url.pathExtension] else {
            throw Error.unsupportedFormat
        }
        guard let data = try? Data(contentsOf: url) else {
            throw Error.unreadableContent
        }
        try self.init(data: data, format: format)
    }
    
    public init(data: Data, format: Format) throws {
        guard let image = Image.formatSources[format]?(data, format) else {
            throw Error.unsupportedFormat
        }
        self.image = image
        self.data = data
        self.format = format.rawValue
    }
    
    // TODO: Implement BitmapInfo and stream support
    public init? (size: Size, bitsPerComponent: BitsPerComponent, bitsPerPixel: UInt8, bytesPerRow: UInt8, info: CGBitmapInfo, provider: CGDataProvider) {
        self.data = Data()
        guard let image = CGImage(width: Int(size.x),
                            height: Int(size.y),
                  bitsPerComponent: Int(bitsPerComponent),
                      bitsPerPixel: Int(bitsPerPixel),
                       bytesPerRow: Int(bytesPerRow),
                             space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: info,
                          provider: provider,
                            decode: nil,
                 shouldInterpolate: true,
                            intent: .defaultIntent) else {
            return nil
        }
        self.image = image
        self.format = UInt8.max
    }
    
    // MARK: - JPEG and PNG Support
    
    private static func imageFrom(_ data: Data, format: Format) -> CGImage? {
        let provider = CGDataProvider(data: data as NSData as CFData)!

        switch format {
        case .jpeg:
            return CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        case .png:
            return CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        }
    }
}
