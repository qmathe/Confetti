
/**
	Copyright (C) 2017 Quentin Mathe

	Date:  December 2017
	License:  MIT
 */

import Foundation
import RxSwift

// MARK: - Types

public typealias Operation<State> = (State) -> (State)

// MARK: - Rx Operators

public extension ObservableType {

    public func mapToOperation() -> Observable<Operation<E>> {
        return map { (value: E) -> Operation<E>  in
            return { _ in value }
        }
    }

    public func update(startingWith initialValue: E, using operation: Observable<Operation<E>>) -> Observable<E> {
        return Observable<Operation<E>>.merge(operation, mapToOperation()).scan(initialValue) { $1($0) }
    }
}

public extension Observable where Element: Placeholder {

    public func update(using operation: Observable<Operation<Element>>) -> Observable<Element> {
        return update(startingWith: Element.placeholder, using: operation)
    }
}
