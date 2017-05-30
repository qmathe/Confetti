/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import Confetti

class Counter: Viewpoint, UI {

    var value: Int

    func counter() -> Item {
        column(items:
            textField(model: self),
            row(items: 
                button(title: "+") { value += 1 },
                button(title: "-") { value +-= 1 }
            )
        )
    }
}
