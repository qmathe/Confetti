/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import RxSwift

public enum SwitchStatus: Int {
	case on
	case off
	case none
}

open class SwitchState: ControlState {

	open var text = ""
    /// Emits a status change event when the switch is clicked or swiped.
    ///
    /// Can be used to change the current status with `status.value = aValue`.
    public let status: Variable<SwitchStatus>
	
	public init(text: String = "", status: SwitchStatus = .off, objectGraph: ObjectGraph) {
		self.text = text
		self.status = Variable(status)
        super.init(objectGraph: objectGraph)
	}
}
