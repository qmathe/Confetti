/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift

class App {
	let presentation: Presentation
	let renderer: Renderer
    var node: Observable<RenderedNode> {
        return update.withLatestFrom(presentation.item).map { [unowned self] item in
            return self.renderer.renderItem(item)
        }
    }
    let update = PublishSubject<Void>()
	
	init(presentation: Presentation, renderer: Renderer) {
		self.presentation = presentation
		self.renderer = renderer
	}
}
