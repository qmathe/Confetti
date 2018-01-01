/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import Confetti
import Tapestry

class TodoApp: Viewpoint<State<[Todo]>>, UI {

	let todoList: TodoList
	let todoEditor: TodoEditor
	override var presentations: [Presentation] { return [todoList, todoEditor] }

	override init(_ value: Observable<[Todo]>, objectGraph: ObjectGraph? = nil) {
		todoList = TodoList(value)
        todoEditor = TodoEditor(editedValue(in: todoList))
        super.init(value, objectGraph: objectGraph)
	}

    override func generate(with value: [Todo]) -> Item {
        return item(frame: Rect(x: 200, y: 200, width: 600, height: 800), items:
			row(items:
				todoList.item,
				todoEditor.item
			)
		)
    }
}

private func editedValue(in todoList: TodoList) -> Observable<Todo?> {
    return todoList.selectionIndexes.mapToFirstElement(in: todoList)
}
