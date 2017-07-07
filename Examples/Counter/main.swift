/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import Confetti
import Tapestry

// PresentationBuilder/Kit
class Counter: Viewpoint<Int>, UI {

    override func generate() -> Item {
        return item(frame: Rect(x: 200, y: 200, width: 200, height: 40), items:
			column(items:
				label(extent: Extent(width: 200, height: 20), text: String(describing: value)),
				row(items:
					button(extent: Extent(width: 100, height: 20), text: "+") { value += 1 },
					button(extent: Extent(width: 100, height: 20), text: "-") { value += 1 }
				)
			)
		)
    }
}

run(Counter(value: 0))
