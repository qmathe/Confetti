/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public enum SwitchStatus: Int {
	case on
	case off
	case none
}

open class SwitchState: ControlState {

	open var text = ""
	open var status = SwitchStatus.off
	
	public init(text: String = "", status: SwitchStatus = .off, objectGraph: ObjectGraph) {
		super.init(objectGraph: objectGraph)
		self.text = text
		self.status = status
	}
}
