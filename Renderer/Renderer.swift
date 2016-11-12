/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

internal protocol RenderableNode {
	func render(renderer: Renderer) -> RenderedNode
}

internal protocol RenderableAspect {
	func render(item: Item, with renderer: Renderer) -> RenderedNode
}

public protocol RenderedNode {

}

public protocol RendererDestination {

}

public protocol Renderer {
	init(destination: RendererDestination?)
	func renderItem(item: Item) -> RenderedNode
    func renderView(item: Item) -> RenderedNode
	func renderButton(item: Item) -> RenderedNode
	func renderLabel(item: Item) -> RenderedNode
	func renderSlider(item: Item) -> RenderedNode
	func renderSwitch(item: Item) -> RenderedNode
}

