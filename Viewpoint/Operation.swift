
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

public extension ObservableType  {

    public func mapToOperation<S: CreatableState>() -> Observable<Operation<S>> where E == S.T  {
        return map { (value: E) -> Operation<S>  in
            return { oldState in
                return oldState.replacing(with: value)
            }
        }
    }

    public func update<S: CreatableState>(startingWith initialValue: S, using operation: Observable<Operation<S>>) -> Observable<S> where E == S.T {
        return Observable
            .merge(operation, mapToOperation())
            .scan(initialValue) { (oldState: S, operation: Operation<S>) -> S in
                return operation(oldState)
            }
            .share(replay: 1, scope: .forever)
    }

    public func update<S: CreatableState>(using operation: Observable<Operation<S>>) -> Observable<S> where E == S.T {
        return update(startingWith: S(), using: operation)
    }
}

