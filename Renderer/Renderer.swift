/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

protocol Rendered {
	func render(renderer: Renderer)
}

protocol RenderedNode {

}

protocol RendererDestination {

}

protocol Renderer {
	init(destination: RendererDestination?)
	func renderItem(item: Item) -> RenderedNode
	func renderButton(item: Button) -> RenderedNode
	func renderLabel(item: Label) -> RenderedNode
}

