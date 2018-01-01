/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import Confetti
import Tapestry

class TodoEditor: Viewpoint<State<Todo?>>, UI {

    override func generate(with value: Todo?) -> Item {
        return label(extent: Extent(width: 600, height: 800), text: value?.text ?? "")
    }
}

