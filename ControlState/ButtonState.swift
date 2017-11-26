/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import RxSwift

open class ButtonState: ControlState {

	open var text = ""
    /// Emits a tap event when the button is touched or clicked.
    ///
    /// Can be used to post a tap event with `tap.onNext(Tap(count: 1))`.
    let tap = PublishSubject<Tap>()

	public init(text: String = "", objectGraph: ObjectGraph) {
		super.init(objectGraph: objectGraph)
		self.text = text
	}
}
