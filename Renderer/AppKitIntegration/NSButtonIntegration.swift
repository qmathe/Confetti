/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

extension Item {

	func reactTo(_ sender: NSButton, isSwitch: Bool) {
	
		if isSwitch {
			let status: SwitchStatus = {
				switch sender.state {
				case NSOnState: return SwitchStatus.on
				case NSOffState: return SwitchStatus.off
				default: return SwitchStatus.none
				}
			}()

			(actionHandlers.first as? SwitchActionHandler)?.toggle(self, toStatus: status.rawValue)
		}
		else {
			(actionHandlers.first as? ButtonActionHandler)?.tap(self)
		}
	}
}
