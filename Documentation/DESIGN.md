Confetti Design
===============

UI Editing
----------

This sketches how we can implement an always available editing mode without conflicting with any existing action handlers.

## FixedLayout

// When geometry is set, handles or control points are visible to resize, rotate and move the element
editingMode = enum { position, geometry }
editingActionHandler


## Item

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
