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
	
	public required init(destination: RendererDestination? = nil) {
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
			renderViews(item.items ?? [], intoView: destination)

			return destination
		}
		else {
			return AppKitRootNode(windows: item.items?.map { renderWindow($0) as! NSWindow } ?? [])
		}
	}
	
	private func renderViews(items: [Item], intoView view: NSView) {
		view.subviews = items.map { $0.render(self) as! NSView }

		// Adjust the origin to compensate the coordinate system differences
		//
		// When the view was instantiated, the superview wasn't available
		// to determine the correct origin.
		view.subviews.forEach { $0.confettiFrame = RectFromCGRect($0.frame) }
	}

	/// Geometry changes requires the parent item to be rendered in the same pass,
	/// otherwise the rendered view won't match the latest size and position.
	private func renderView(item: Item) -> RenderedNode {
		let view = viewForItem(item) { NSView(frame: CGRectFromRect(item.frame)) }

		renderViews(item.items ?? [], intoView: view)
		return view
	}

	/// For a window unlike a view, we can determine the correct origin 
	/// immediately, since we can know the screen where it will appear.
	private func renderWindow(item: Item) -> RenderedNode {
		let styleMask: Int = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask | NSUnifiedTitleAndToolbarWindowMask
		let window = nodeForItem(item, in: &windows) { NSWindow(contentRect: CGRectFromRect(item.frame), styleMask: styleMask, backing: .Buffered, defer: false) }
		
		window.contentView = (item.render(self) as! NSView)

		if item.isFrontmost {
			window.makeKeyWindow()
		}
		window.orderFront(nil)

		// Adjust the origin to compensate coordinate system differences
		window.confettiFrame = item.frame

		return window
	}

	public func renderButton(item: Item) -> RenderedNode {
		let button = viewForItem(item) { NSButton(frame: CGRectFromRect(item.frame)) } as! NSButton
		
		button.title = (item.controlState as? ButtonState)?.text ?? ""
		button.setAction { [weak item = item] (sender: NSButton) in item?.reactTo(sender, isSwitch: false) }

		return button
	}
	
	public func renderLabel(item: Item) -> RenderedNode {
		let label = viewForItem(item) { NSTextField(frame: CGRectFromRect(item.frame)) } as! NSTextField
		
		label.stringValue = (item as? ButtonState)?.text ?? ""
		label.bezeled = false
		label.drawsBackground = false
		label.editable = false
		label.selectable = false

		return label
	}
	
	public func renderSlider(item: Item) -> RenderedNode {
		let slider = viewForItem(item) { NSSlider(frame: CGRectFromRect(item.frame)) } as! NSSlider
		let state = item.controlState as? SliderState
	
		slider.minValue = Double(state?.minValue ?? 0)
		slider.maxValue = Double(state?.maxValue ?? 0)
		slider.objectValue = state?.initialValue ?? 0
		slider.setAction { [weak item = item] (sender: NSSlider) in item?.reactTo(sender) }

		if item.orientation == .Horizontal {
			slider.frame.size.height = defaultSliderThickness
		}
		else {
			slider.frame.size.width = defaultSliderThickness
		}

		return slider
	}
	
	public func renderSwitch(item: Item) -> RenderedNode {
		let button = viewForItem(item) { NSButton(frame: CGRectFromRect(item.frame)) } as! NSButton
		
		button.frame.size.height = defaultSwitchHeight
		button.title = (item.controlState as? SwitchState)?.text ?? ""
		button.state = (item.controlState as? SwitchState)?.status.rawValue ?? 0
		button.setButtonType(.SwitchButton)
		button.setAction { [weak item = item] (sender: NSButton) in item?.reactTo(sender, isSwitch: true) }

		return button
	}
	
	// MARK: - Position and Size Constants
	
	var defaultSwitchHeight: CGFloat = 18
	var defaultSliderThickness: CGFloat = 21
	
	func reactToActionFrom(sender: NSObject) {
		
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

extension NSView: RendererDestination, RenderedNode {

	internal var confettiFrame: Rect {
		get {
			if let superview = superview where superview.flipped == false {
				var rect = frame
				rect.origin.y = superview.frame.size.height - frame.maxY
				return RectFromCGRect(rect)
			}
			else {
				return RectFromCGRect(frame)
			}
		}
		set {
			if let superview = superview where superview.flipped == false {
				var rect = CGRectFromRect(newValue)
				rect.origin.y = superview.frame.size.height - rect.maxY
				frame = rect
			}
			else {
				frame = CGRectFromRect(newValue)
			}
		}
	}
}

extension NSWindow: RenderedNode {

	internal var confettiFrame: Rect {
		get {
			if let screen = screen {
				var rect = frame
				rect.origin.y = screen.visibleFrame.size.height - frame.maxY
				return RectFromCGRect(contentRectForFrameRect(rect))
			}
			else {
				return RectFromCGRect(contentRectForFrameRect(frame))
			}
		}
		set {
			if let screen = screen {
				var rect = frameRectForContentRect(CGRectFromRect(newValue))
				rect.origin.y = screen.visibleFrame.size.height - rect.maxY
				setFrame(rect, display: false)
			}
			else {
				setFrame(frameRectForContentRect(CGRectFromRect(newValue)), display: false)
			}
		}
	}
}

/// A dummy node returned when the rendered item is the root item.
class AppKitRootNode: RenderedNode {
	let windows: [NSWindow]
	
	init(windows: [NSWindow]) {
		self.windows = windows
	}
}
