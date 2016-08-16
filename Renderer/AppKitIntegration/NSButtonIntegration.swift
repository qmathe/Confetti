/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

extension Switch {

	dynamic func reactTo(sender: NSButton) {
		let state: SwitchState = {
			switch sender.state {
			case NSOnState: return SwitchState.On
			case NSOffState: return SwitchState.Off
			default: return SwitchState.None
			}
		}()

		toggle(state.rawValue)
	}
}
