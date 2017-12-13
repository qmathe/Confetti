/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

public struct Drag {
    
    // TODO: May be evolve towards Item.representations: [UTI: Any] and Item.type: AnyType where the
    // the latter is the type to get the original or best representation.
    
    /// An item wrapping a distinct drag element and its preview.
    ///
    /// Can represent a text chunk, photo or row. For multiple elements, it's usually better to
    /// wrap them into distinct items to support:
    ///
    /// - better previews
    /// - drop validation per item
    ///
    /// The last point means the drag destination can filter out items according to their
    /// content types or some other criterias.
    public struct Item {
        /// The dragged object or value.
        public var content: Any
        /// The content type.
        public var type: Any.Type
    }
    
    // MARK: - Starting and Stopping Drags
    
    public static let begin = PublishSubject<Drag>()
    public static let end = PublishSubject<Drag>()
    
    // MARK: - Reacting to Drags

    public static let update = Observable<Drag>.empty()
    
    // MARK: - Content
    
    /// The items representing distinct elements taking part in the drag.
    public var items: [Item]
}
