/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

extension Item {

	func reactTo(sender: NSButton, isSwitch: Bool) {
	
		if isSwitch {
			let status: SwitchStatus = {
				switch sender.state {
				case NSOnState: return SwitchStatus.On
				case NSOffState: return SwitchStatus.Off
				default: return SwitchStatus.None
				}
			}()

			(actionHandlers.first as? SwitchActionHandler)?.toggle(self, toStatus: status.rawValue)
		}
		else {
			(actionHandlers.first as? ButtonActionHandler)?.tap(self)
		}
	}
}
