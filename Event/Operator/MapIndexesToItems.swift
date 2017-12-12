/**
	Copyright (C) 2017 Quentin Mathe

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

public extension Observable where Element == IndexSet {
    
    /// Returns items matching selection indexes in the given viewpoint presenting item.
    public func mapToElements<T>(in viewpoint: CollectionViewpoint<T>) -> Observable<[Item]> {
        return map { viewpoint.itemPresentingCollection(from: viewpoint.item).items?[$0] ?? [] }
    }
}
