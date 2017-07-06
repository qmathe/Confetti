/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import Confetti
import Tapestry

class Counter: Viewpoint<Int>, UI {

    override func generate() -> Item {
        return column(items:
            label(extent: Extent(width: 200, height: 20), text: "0"),
            row(items: 
                button(extent: Extent(width: 100, height: 20), text: "+") { value += 1 },
                button(extent: Extent(width: 100, height: 20), text: "-") { value += 1 }
            )
        )
    }
}
