/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

internal protocol RenderableNode {
	func render(_ renderer: Renderer) -> RenderedNode
}

internal protocol RenderableAspect {
	func render(_ item: Item, with renderer: Renderer) -> RenderedNode
}

public protocol RenderedNode {

}

public protocol RendererDestination {

}

public protocol Renderer {
	init(destination: RendererDestination?)
	func renderItem(_ item: Item) -> RenderedNode
    func renderView(_ item: Item) -> RenderedNode
	func renderButton(_ item: Item) -> RenderedNode
	func renderLabel(_ item: Item) -> RenderedNode
	func renderSlider(_ item: Item) -> RenderedNode
	func renderSwitch(_ item: Item) -> RenderedNode
}

