/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift

class App {
    private let bag = DisposeBag()
	let presentation: Presentation
	let renderer: Renderer
    let node: Observable<RenderedNode>
    let update = PublishSubject<Void>()
	
	init(presentation: Presentation, renderer: Renderer) {
        let item = presentation.item.map { ($0, Date()) }

		self.presentation = presentation
		self.renderer = renderer
        self.node = update.withLatestFrom(item).distinctUntilChanged {  $0.1 == $1.1 }.map {
            print("Render")
            return renderer.renderItem($0.0)
        }
        self.node.publish().connect().disposed(by: bag)
	}
}
