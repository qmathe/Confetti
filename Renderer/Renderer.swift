/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

internal protocol Rendered {
	func render(renderer: Renderer) -> RenderedNode
}

public protocol RenderedNode {

}

public protocol RendererDestination {

}

public protocol Renderer {
	init(destination: RendererDestination?)
	func renderItem(item: Item) -> RenderedNode
	func renderButton(item: Button) -> RenderedNode
	func renderLabel(item: Label) -> RenderedNode
}

