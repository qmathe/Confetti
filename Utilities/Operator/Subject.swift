/**
	Copyright (C) 2017 Quentin Mathe

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

postfix operator ^

public postfix func ^ <T>(subject: BehaviorSubject<T>) -> T {
    return try! subject.value()
}

infix operator =^ : SubjectAccept

precedencegroup SubjectAccept {
    higherThan: BitwiseShiftPrecedence
}

public func =^ <T>(subject: BehaviorSubject<T>, value: T) {
    subject.onNext(value)
}

public extension BehaviorSubject {

    public func update(_ closure: (E) -> (E)) {
        onNext(closure(try! value()))
    }
}

public extension Observable {

    public func bind<O: ObserverType>(to observer: O) -> Disposable where O.E == E {
        return subscribe { event in
            switch event {
            case .completed:
                break
            default:
                observer.on(event)
            }
        }
    }
}
