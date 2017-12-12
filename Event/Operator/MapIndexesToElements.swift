/**s

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

public extension Observable where Element == IndexSet {
    
    /// Returns elements matching selection indexes in collection presented by the given viewpoint.
    public func mapToElements<T>(in viewpoint: CollectionViewpoint<T>) -> Observable<[T]> {
        return Observable<[T]>.combineLatest(self, viewpoint.content) { indexes, collection in
            return collection[indexes]
        }
    }
    
    /// Returns the element matching first selection index in collection presented by the given viewpoint.
    public func mapToFirstElement<T>(in viewpoint: CollectionViewpoint<T>) -> Observable<T?> {
        return mapToElements(in: viewpoint).flatMap { (elements: [T]) -> Observable<T?> in
            return .just(elements.first)
        }
    }
}
