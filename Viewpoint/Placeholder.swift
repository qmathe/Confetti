/**
	Copyright (C) 2017 Quentin Mathe

	Date:  December 2017
	License:  MIT
 */

import Foundation

/// Placeholder protocol implemented by `Viewpoint`.
public protocol Placeholder {

    /// A placeholder replacing a presented value when the latter is not available.
    static var placeholder: Self { get }
}

/// Default implementation of `Placeholder` protocol` for arrays.
extension Array: Placeholder {

    /// Returns an empty array.
    public static var placeholder: Array<Element> { return Array() }
}

/// Default implementation of `Placeholder` protocol` for integers.
extension Int: Placeholder {
    
    /// Returns zero.
    public static var placeholder: Int { return 0 }
}

/// Default implementation of `Placeholder` protocol for optional values.
extension Optional: Placeholder {

    /// Returns nil
    public static var placeholder: Optional {
        return nil
    }
}
