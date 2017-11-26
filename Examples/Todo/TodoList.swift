/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import Confetti
import Tapestry

class TodoList: CollectionViewpoint<Todo>, UI {

	// TODO: Remove
	override init<S>(_ collection: S, objectGraph: ObjectGraph? = nil) where S : Sequence, S.Iterator.Element == Todo {
		super.init(collection, objectGraph: objectGraph)
	}
	
	override func itemPresentingCollection(from item: Item) -> Item {
		return (item.items ?? [])[0]
	}

    override func generate() -> Item {
        return column(items:
			column(items:
                collection.map { self.label(extent: Extent(width: 400, height: 50), text: $0.text) },
                   select: { _ in self.send(self.selectedElements.first) }
			),
			row(items:
				button(extent: Extent(width: 200, height: 20), text: "Add", action: { _ in self.add() }),
				button(extent: Extent(width: 200, height: 20), text: "Remove", action: { _ in self.remove() })
			)
		)
    }
}

