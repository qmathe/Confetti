/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

open class ButtonState: ControlState {

	open var text = ""
	
	public init(text: String = "", objectGraph: ObjectGraph) {
		super.init(objectGraph: objectGraph)
		self.text = text
	}
}
