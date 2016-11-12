/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

open class SliderState: ControlState {

	open var minValue: VectorFloat = 0
	open var maxValue: VectorFloat = 0
	open var initialValue: VectorFloat = 0
	open var currentValue: VectorFloat = 0

	public init(min: VectorFloat = 0, max: VectorFloat, initial: VectorFloat, objectGraph: ObjectGraph) {
		super.init(objectGraph: objectGraph)
		self.minValue = min
		self.maxValue = max
		self.initialValue = initial
		self.currentValue = initial
	}
}
