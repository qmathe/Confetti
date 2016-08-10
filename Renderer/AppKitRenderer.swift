/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

extension SequenceType where Generator.Element : Equatable {

	func contains(element: Self.Generator.Element?) -> Bool {
		guard let e = element else {
			return false
		}
		return contains(e)
	}
}

/**
 * To generate a AppKit UI, do item.render(AppKitRenderer()).
 */
public class AppKitRenderer: Renderer {

	public let destination: NSView?
	internal var windows = [Item: NSWindow]()
	internal var views = [Item: NSView]()
	internal var startItem: Item?
	
	public required init(destination: RendererDestination?) {
		guard let destination = destination as? NSView? else {
			fatalError("Unsupported destination type")
		}
		self.destination = destination
	}
	
	private func viewForItem(item: Item, create: (() -> NSView)) -> NSView {
		return nodeForItem(item, in: &views, create: create)
	}
	
	private func nodeForItem<K, V>(item: K, inout in nodes: [K: V], create: (() -> V)) -> V {
		if let node = nodes[item] {
			return node
		}
		else {
			let node = create()
			nodes[item] = node
			return node
		}
	}
	
	private func discardUnusedNodesFor(newStartItem: Item, oldStartItem: Item?) {
		let existingViews = Set(views.values)
		let existingWindowBackedItems = Set(windows.keys)
		let keptItems = Set(ItemTreeGenerator(item: newStartItem).descendantItems)
		
		for (item, window) in windows {
			
			if keptItems.contains(item) {
				precondition(existingViews.contains(window.contentView))
				continue
			}

			windows.removeValueForKey(item)
			window.orderOut(nil)
			// FIXME: window.close()
		}
		
		for (item, view) in views {
		
			if keptItems.contains(item) {

				if let superview = view.superview
				 where item != oldStartItem && item != newStartItem {

					precondition(existingViews.contains(superview) || existingWindowBackedItems.contains(item))
				}
				else {
					precondition(view == destination)
				}
				continue
			}

			views.removeValueForKey(item)
			if item == oldStartItem {
				view.removeFromSuperview()
			}
		}
	}

	/// Initiates a recursive rendering starting at the given item.
	///
	/// The start item can be a root item or not, but will always correspond to 
	/// the root rendered node.
	///
	/// This method is never called recursively.
	public func renderItem(item: Item) -> RenderedNode {
		defer {
			discardUnusedNodesFor(item, oldStartItem: startItem)
			startItem = item
		}

		if item.isRoot {
			return renderRoot(item)
		}
		else {
			return renderView(item)
		}
	}
	
	private func renderRoot(item: Item) -> RenderedNode {
		if let destination = destination {
		
			views[item] = destination
			// Don't resize or move the destination
			destination.subviews = item.items?.map { $0.render(self) as! NSView } ?? []

			return destination
		}
		else {
			return AppKitRootNode(windows: item.items?.map { renderWindow($0) as! NSWindow } ?? [])
		}
	}

	private func renderView(item: Item) -> RenderedNode {
		let view = viewForItem(item) { NSView(frame: CGRectFromRect(item.frame)) }

		view.subviews = item.items?.map { $0.render(self) as! NSView } ?? []

		return view
	}

	private func renderWindow(item: Item) -> RenderedNode {
		let styleMask: Int = NSBorderlessWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask | NSUnifiedTitleAndToolbarWindowMask
		let window = nodeForItem(item, in: &windows) { NSWindow(contentRect: CGRectFromRect(item.frame), styleMask: styleMask, backing: .Buffered, defer: false) }
		
		window.contentView = (item.render(self) as! NSView)

		if item.isFrontmost {
			window.makeKeyWindow()
		}
		window.orderFront(nil)

		return window
	}

	public func renderButton(item: Button) -> RenderedNode {
		let button = viewForItem(item) { NSButton(frame: CGRectFromRect(item.frame)) } as! NSButton
		
		button.title = item.text

		return button
	}
	
	public func renderLabel(item: Label) -> RenderedNode {
		let label = viewForItem(item) { NSTextField(frame: CGRectFromRect(item.frame)) } as! NSTextField
		
		label.stringValue = item.text
		label.bezeled = false
		label.drawsBackground = false
		label.editable = false
		label.selectable = false

		return label
	}
}


// MARK: - Utilities

internal func RectFromCGRect(rect: CGRect) -> Rect {
	return Rect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
}

internal func CGRectFromRect(rect: Rect) -> CGRect {
	return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.extent.width, height: rect.extent.height)
}

// MARK: - Rendered Nodes

extension NSView: RendererDestination, RenderedNode { }
extension NSWindow: RenderedNode { }

/// A dummy node returned when the rendered item is the root item.
class AppKitRootNode: RenderedNode {
	let windows: [NSWindow]
	
	init(windows: [NSWindow]) {
		self.windows = windows
	}
}
