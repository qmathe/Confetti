/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public enum SwitchStatus: Int {
	case On
	case Off
	case None
}

public class SwitchState: ControlState {

	public var text = ""
	public var status = SwitchStatus.Off
	
	public init(text: String = "", status: SwitchStatus = .Off, objectGraph: ObjectGraph) {
		super.init(objectGraph: objectGraph)
		self.text = text
		self.status = status
	}
}
