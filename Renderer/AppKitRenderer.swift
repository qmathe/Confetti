/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

/**
 * To generate a AppKit UI, do item.render(AppKitRenderer()).
 */
class AppKitRenderer: Renderer {

	var destination: NSView?
	var windows = [Item: NSWindow]()
	var views = [Item: NSView]()
	
	required init(destination: RendererDestination?) {
		guard let destination = destination as? NSView else {
			fatalError("Unsupported destination type")
		}
		self.destination = destination
	}
	
	func viewForItem(item: Item, create: (() -> NSView)) -> NSView {
		return nodeForItem(item, in: &views, create: create)
	}
	
	func nodeForItem<K, V>(item: K, inout in nodes: [K: V], create: (() -> V)) -> V {
		if let node = nodes[item] {
			return node
		}
		else {
			let node = create()
			nodes[item] = node
			return node
		}
	}
	
	func discardUnusedNodesFor(startItem: Item) {
		let viewSet = Set(views.values)
		
		for (item, view) in views {
		
			guard let parent = item.parent else {
				precondition(item == startItem)
				continue
			}

			if views[parent] == nil {
				view.removeFromSuperview()
				views.removeValueForKey(item)
			}
			else {
				precondition(view.superview != nil)
				precondition(viewSet.contains(view.superview!))
			}
		}
	}

	/// This method is called to initiate the rendering, but never recursively.
	func renderItem(item: Item) -> RenderedNode {

		if destination == nil && item.isRoot {
			return renderRoot(item)
		}
		else if item.parent?.isRoot == true {
			return renderWindow(item)
		}
		else {
			return renderView(item)
		}
		
		discardUnusedNodesFor(item)
	}
	
	private func renderRoot(item: Item) -> RenderedNode {
		if let destination = destination {
			// Don't resize or move the destination
			destination.subviews = item.items?.map { $0.render(self) as! NSView } ?? []
			return destination
		}
		else {
			item.items?.map { renderWindow($0) }
			return AppKitRootNode()
		}
	}

	private func renderView(item: Item) -> RenderedNode {
		let view = viewForItem(item) { NSView(frame: NSRectFromFrame(item.frame)) }

		view.subviews = item.items?.map { $0.render(self) as! NSView } ?? []

		return view
	}

	private func renderWindow(item: Item) -> RenderedNode {
		let window = nodeForItem(item, in: &windows) { NSWindow() }
		
		window.setFrame(window.frameRectForContentRect(NSRectFromFrame(item.frame)), display: false)
		window.contentView = renderView(item) as! NSView
		
		if item.isFrontmost {
			window.makeKeyWindow()
		}
		window.orderFront(nil)

		return window
	}

	func renderButton(item: Button) -> RenderedNode {
		let button = viewForItem(item) { NSButton(frame: NSRectFromFrame(item.frame)) }
		
		return button
	}
	
	func renderLabel(item: Label) -> RenderedNode {
		let label = viewForItem(item) { NSTextField(frame: NSRectFromFrame(item.frame)) } as! NSTextField
		
		label.bezeled = false
		label.drawsBackground = false
		label.editable = false
		label.selectable = false

		return label
	}
}


// MARK: - Utilities

private func NSRectFromFrame(frame: Rect) -> CGRect {
	return NSRect(x: frame.origin.x, y: frame.origin.y, width: frame.extent.width, height: frame.extent.height)
}

// MARK: - Rendered Nodes

extension NSView: RendererDestination, RenderedNode { }
extension NSWindow: RenderedNode { }
/// A dummy node returned when the rendered item is the root item.
class AppKitRootNode: RenderedNode { }
