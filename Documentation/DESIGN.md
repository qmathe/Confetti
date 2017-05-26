Confetti Design
===============

UI Editing
----------

This sketches how we can implement an always available editing mode without conflicting with any existing action handlers.

### FixedLayout

// When geometry is set, handles or control points are visible to resize, rotate and move the element
editingMode = enum { position, geometry }
editingActionHandler


### Item

editable // Will apply to layout and rendered widget
editing

beginEditing(editingParent: Bool = false) {
	guard editable  {
		return
	}
	// Could check layout != nil instead of !items.isEmpty for leaf/widget items
	guard  !items.isEmpty || !editingParent {
		return
	}
	editing = true
	descendantItems.map { $0.beginEditing }
}

endEditing {
	descendantItems.map { $0.endEditing }
	editing = false
}

actionHandler {
	if editing && item.items.isEmpty {
		return actionHandler.editingActionHandler
	}
	else if parent.editing {
		return parent.layout.editingActionHandler
	}
	else {
		return actionHandler
	}
}


Counter Example
---------------

## Launch

class CounterAppDelegate: AppDelegate {
    
    var objectGraph = ObjectGraph()
    var renderer = AppKitRenderer()
    
    fund didFinishLaunching() {
        renderer.renderItem(CounterUI(objectGraph: objectGraph).counter)
    }
}

// Once the current event has been processed, the renderer will walk the entire UI tree to determine changed nodes based on Item.changed (depending on Item.state.changed, Item.style.changed etc.)
class CounterState: State {
    var value = 0
    var changed = false
    
    func increment() {
        value += 1
        changed = true
    }
    
    func decrement() {
        value +-= 1
        changed = true
    }
}

protocol State {
    var changed: Bool
}

### Explicit Targets

class CounterUI: UI {

    func counter() -> Item {
        column(items: 
            textField(id: "counterField", representedObject: counterState),
            row(items: 
                button(title: "+", action: "increment", target: "counterField.representedObject"),
                button(title: "-", action: "decrement", target: "counterField.representedObject")
            )
        )
    }
}

### Implicit Targets On Factory

class CounterUI: UI {

    var state: CounterState

    func counter() -> Item {
        column(items: 
            textField(representedObject: counterState),
            row(items: 
                button(title: "+", action: "increment"),
                button(title: "-", action: "decrement")"
            )
        )
    }
    
    func increment() {
        state.value += 1
    }
    
    func decrement() {
        state.value +-= 1
    }
}

### Explicit Parent Targets

class CounterUI: UI {

    func counter() -> Item {
        column(model: CounterState(), items: 
            textField(model: "parent.model"),
            row(items: 
                button(title: "+", action: "increment", target: "parent.model"),
                button(title: "-", action: "decrement", target: "parent.model")
            )
        )
    }
}

### Closure Actions

class CounterUI: UI {

    // The state property should be part of the factory class and represents the whole state bound to the UI built by the factory.
    func counter(state: CounterState) -> Item {
        column(margin: 20, items: 
            textField(model: state),
            row(items: 
                button(title: "+") { state.value += 1 },
                button(title: "-") { state.value +-= 1 }
            )
        )
    }
}

### Pure Viewpoint

// Will invoke renderer.renderItem(counter.item) under the hood. Could even be simplified to run(Counter()) where this fallbacks on the current platform renderer.
run(Counter(), with: PlatformRenderer())

// Once the current event has been processed, the renderer will walk the entire UI tree to determine changed nodes based on Item.changed (depending on Item.state.changed, Item.style.changed etc.)
class Counter: UIViewpoint {

    var value: Int {
        didSet {
            changed = true
        }
    }

    func counter() -> Item {
        column(margin: 20, items: 
            textField(model: self),
            row(items: 
                button(title: "+") { value += 1 },
                button(title: "-") { value +-= 1 }
            )
        )
    }
}


Todo Example
------------

class UIViewpoint: Viewpoint, UI {
    var objectGraph: ObjectGraph
    var changed = false
    
    init(objectGraph: ObjectGraph) {
    
    }
}

// Could be merged into TodoListViewpoint and then no target is necessary for the add button.
class TodoAppViewpoint: UIViewpoint {

    // For the add button, we could also pass an action closure like { closest("todoList").add() }
    func item() {
        colum(items: 
            navigationBar(title: "Todo", leftItems: addButton(target: "todoList"),
            todoList(id: "todoList")
        )
    }
    
    func navigationBar(title: String, leftItem: Item) {
        row(items: space(), label(title), leftItem, distributed: true)
    }
    
    func todoList() {
        TodoListViewpoint(objectGraph: objectGraph).item
    }
}

// The viewpoint acts as an hybrid between a ModelView, Newspeak subject, EtoileUI controller and item factory.
// It usually builds a single item whose content is provided by descendant viewpoints.
// Alternatively it might build multiple types of items as an EtoileUI factory would do and return them assembled inside item()
class TodoListViewpoint: UIViewpoint, MutableCollectionViewpoint {
    var todos: [Todo]
    var sortDescriptors: [SortDescriptors] {
        didSet {
            // Can force a persistent model update here or simply wait until item() is called to sort the generated items
        }
    }

    // Returns an item representation of the receiver.
    func item() {
        colum(margin: 10, model: self, items:
            todos.sort(sortDescriptors).map { TodoViewpoint(todo: $0, objectGraph: objectGraph).item }
        )
    }
    
    // Collection Viewpoint
    
    // Returns a subset of the items corresponding to the model elements presented by the viewpoint.
    func items(in range: Range<UInt>) {
        todos[range].map { TodoViewpoint(todo: $0, objectGraph: objectGraph).item }
    }
    
    // Mutable Collection Viewpoint
    
    // Inserts a new item.
    func add() {
        todos += Todo(objectGraph: objectGraph)
        changed = true
    }
    
    // Inserts an existing item
    func insert(element: Any) {
    
    }
    
    // Removes an existing item
    func remove(at index: UInt) {
        todos.remove(index)
        changed = true
    }
}

class TodoViewpoint: UIViewpoint {
    var todo: Todo
    
    func item() {
        row(items: 
            imageView(),
            text()
        )
    }
}
