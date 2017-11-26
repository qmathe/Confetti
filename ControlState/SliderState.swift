/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import RxSwift
import Tapestry

/**
To detect when the user stops to drag the slider thumb, observe when the editing
ends.

Note: there is no continuous property, but you can observe the editing cycle
(begin/change/end) to get the same results.
*/
open class SliderState: ControlState {

	open var minValue: VectorFloat = 0
	open var maxValue: VectorFloat = 0
	open var initialValue: VectorFloat = 0
    /// Emits a value change event when the slider is clicked, dragged or panned.
    ///
    /// Can be used to change the current value with `currentValue.value = aValue`.
	public let currentValue: Variable<VectorFloat>

	public init(min: VectorFloat = 0, max: VectorFloat, initial: VectorFloat, objectGraph: ObjectGraph) {
		self.minValue = min
		self.maxValue = max
		self.initialValue = initial
		self.currentValue = Variable(initial)
        super.init(objectGraph: objectGraph)
	}
}
