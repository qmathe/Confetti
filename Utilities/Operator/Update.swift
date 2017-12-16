/**
	Copyright (C) 2017 Quentin Mathe

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

public extension ObservableType {
    
    public func update(_ initialValue: E) -> Observable<(E, E)> {
        return scan((initialValue, initialValue)) { (value: (old: E, new: E), newValue: E) -> (E, E) in
            return (value.new, newValue)
        }
    }
}

