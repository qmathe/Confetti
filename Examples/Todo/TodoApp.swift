/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import Confetti
import Tapestry

class TodoApp: Viewpoint<[Todo]>, UI {
    
    let bag = DisposeBag()
	let todoList: TodoList
	let todoEditor: TodoEditor
	override var presentations: [Presentation] { return [todoList, todoEditor] }
	
	override init(_ value: [Todo], objectGraph: ObjectGraph? = nil) {
		todoList = TodoList(value)
		todoEditor = TodoEditor(value.first)
		super.init(value, objectGraph: objectGraph)
        prepareEditedTodoUpdate()
	}

    override func generate() -> Item {
        return item(frame: Rect(x: 200, y: 200, width: 600, height: 800), items:
			row(items:
				todoList.item,
				todoEditor.item
			)
		)
    }

    func prepareEditedTodoUpdate() {
        todoList.selection.map { self.todoList.collection[$0] }.subscribe(onNext: { [unowned self] todos in
            self.todoEditor.value = todos.first
        }).disposed(by: bag)
    }
}

