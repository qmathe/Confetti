/**s

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

public extension Observable where Element == IndexSet {
    
    /// Returns elements matching selection indexes in collection presented by the given viewpoint.
    public func mapToElements<E, S>(in viewpoint: CollectionViewpoint<S>) -> Observable<[E]> where E == CollectionViewpoint<S>.E {
        return withLatestFrom(viewpoint.collection) { (indexes: IndexSet, collection: [E]) -> [E] in
            return collection[indexes]
        }
    }
    
    /// Returns the element matching first selection index in collection presented by the given viewpoint.
    public func mapToFirstElement<E, S>(in viewpoint: CollectionViewpoint<S>) -> Observable<E?> where E == CollectionViewpoint<S>.E {
        return mapToElements(in: viewpoint).flatMap { (elements: [E]) -> Observable<E?> in
            return .just(elements.first)
        }
    }
}
