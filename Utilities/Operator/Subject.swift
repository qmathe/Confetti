/**
	Copyright (C) 2017 Quentin Mathe

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift
import RxCocoa

postfix operator ^

public postfix func ^ <T>(subject: BehaviorRelay<T>) -> T {
    return subject.value
}

infix operator =^ : SubjectAccept

precedencegroup SubjectAccept {
    higherThan: BitwiseShiftPrecedence
}

public func =^ <T>(subject: BehaviorRelay<T>, value: T) {
    subject.accept(value)
}

public extension BehaviorRelay {

    public func update(_ closure: (E) -> (E)) {
        accept(closure(value))
    }
}
