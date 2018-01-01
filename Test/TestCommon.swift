/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import XCTest
import RxSwift
import RxBlocking

// MARK: - Asynchronous Testing

extension XCTestCase {

    func waitUntil(_ timeout: TimeInterval = 2, condition: () -> Bool) {
        let timeoutDate = Date(timeIntervalSinceNow: timeout)

        while !condition() && Date() < timeoutDate {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.000001))
        }
    }
}

extension ObservableConvertibleType {

    public func wait(_ timeout: TimeInterval = 2) -> RxBlocking.BlockingObservable<Self.E> {
        return toBlocking(timeout: timeout)
    }
}
