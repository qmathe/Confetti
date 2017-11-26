/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import RxSwift

open class ControlState: UIObject {

    /// Emits a multi-touch event when the button is touched or clicked.
    ///
    /// Can be used to post a multi-touch event with `tap.onNext([touch])`.
    let touches = PublishSubject<[Touch]>()
}
