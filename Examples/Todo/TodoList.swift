/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import Confetti
import Tapestry

class TodoList: CollectionViewpoint<CollectionState<Todo>>, UI {
	
	override func itemPresentingCollection(from item: Item) -> Item {
		return (item.items ?? [])[0]
	}

    override func generate(with collection: [Todo]) -> Item {
        return column(items:
			column(items:
                collection.map { self.label(extent: Extent(width: 400, height: 50), text: $0.text) },
                   touches: { touches, column in
                    touches.mapToIndexes(in: column, combinedWithSelectionFrom: self).bind(to: select).disposed(by: bag)
                }
			),
			row(items:
                button(extent: Extent(width: 200, height: 20), text: "Add", tap: add),
				button(extent: Extent(width: 200, height: 20), text: "Remove", tap: remove)
			)
		)
    }
}

