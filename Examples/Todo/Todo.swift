/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import Confetti

struct Todo: CreatableElement {

    static var counter = 0
    var text: String
	
	init() {
        let baseName = "Untitled"
        text = Todo.counter > 0 ? "\(baseName) \(Todo.counter)" : baseName
        Todo.counter += 1
    }
}
