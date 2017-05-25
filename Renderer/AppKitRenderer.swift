/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation
import Tapestry

extension Sequence where Iterator.Element : Equatable {

	func contains(_ element: Self.Iterator.Element?) -> Bool {
		guard let e = element else {
			return false
		}
		return contains(e)
	}
}

/**
 * To generate a AppKit UI, do item.render(AppKitRenderer()).
 */
open class AppKitRenderer: Renderer {

	open let destination: NSView?
	internal var windows = [Item: NSWindow]()
	internal var views = [Item: NSView]()
	internal var startItem: Item?
	
	public required init(destination: RendererDestination? = nil) {
		guard let destination = destination as? NSView? else {
			fatalError("Unsupported destination type")
		}
		self.destination = destination
	}
	
	fileprivate func viewForItem(_ item: Item, create: (() -> NSView)) -> NSView {
		return nodeForItem(item, in: &views, create: create)
	}
	
	fileprivate func nodeForItem<K, V>(_ item: K, in nodes: inout [K: V], create: (() -> V)) -> V {
		if let node = nodes[item] {
			return node
		}
		else {
			let node = create()
			nodes[item] = node
			return node
		}
	}
	
	fileprivate func discardUnusedNodesFor(_ newStartItem: Item, oldStartItem: Item?) {
		let existingViews = Set(views.values)
		let existingWindowBackedItems = Set(windows.keys)
		let keptItems = Set(ItemTreeIterator(item: newStartItem).descendantItems)
		
		for (item, window) in windows {
			
			if keptItems.contains(item) {
				precondition(existingViews.contains(window.contentView))
				continue
			}

			windows.removeValue(forKey: item)
			window.orderOut(nil)
			// FIXME: window.close()
		}
		
		for (item, view) in views {
		
			if keptItems.contains(item) {

				if let superview = view.superview
				 , item != oldStartItem && item != newStartItem {

					precondition(existingViews.contains(superview) || existingWindowBackedItems.contains(item))
				}
				else {
					precondition(view == destination)
				}
				continue
			}

			views.removeValue(forKey: item)
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
	open func renderItem(_ item: Item) -> RenderedNode {
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
	
	fileprivate func renderRoot(_ item: Item) -> RenderedNode {
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
	
	fileprivate func renderViews(_ items: [Item], intoView view: NSView) {
		view.subviews = items.map { $0.render(self) as! NSView }

		// Adjust the origin to compensate the coordinate system differences
		//
		// When the view was instantiated, the superview wasn't available
		// to determine the correct origin.
		view.subviews.forEach { $0.confettiFrame = RectFromCGRect($0.frame) }
	}

	/// Geometry changes requires the parent item to be rendered in the same pass,
	/// otherwise the rendered view won't match the latest size and position.
	open func renderView(_ item: Item) -> RenderedNode {
		let view = viewForItem(item) { NSView(frame: CGRectFromRect(item.frame)) }

		renderViews(item.items ?? [], intoView: view)
		return view
	}

	/// For a window unlike a view, we can determine the correct origin 
	/// immediately, since we can know the screen where it will appear.
	fileprivate func renderWindow(_ item: Item) -> RenderedNode {
		let styleMask: NSWindowStyleMask = [NSWindowStyleMask.titled, NSWindowStyleMask.closable, NSWindowStyleMask.miniaturizable, NSWindowStyleMask.resizable, NSWindowStyleMask.unifiedTitleAndToolbar]
		let window = nodeForItem(item, in: &windows) { NSWindow(contentRect: CGRectFromRect(item.frame), styleMask: styleMask, backing: .buffered, defer: false) }
		
		window.contentView = (item.render(self) as! NSView)

		if item.isFrontmost {
			window.makeKey()
		}
		window.orderFront(nil)

		// Adjust the origin to compensate coordinate system differences
		window.confettiFrame = item.frame

		return window
	}

	open func renderButton(_ item: Item) -> RenderedNode {
		let button = viewForItem(item) { NSButton(frame: CGRectFromRect(item.frame)) } as! NSButton
		
		button.title = (item.controlState as? ButtonState)?.text ?? ""
		button.setAction { [weak item = item] (sender: NSButton) in item?.reactTo(sender, isSwitch: false) }

		return button
	}
	
	open func renderLabel(_ item: Item) -> RenderedNode {
		let label = viewForItem(item) { NSTextField(frame: CGRectFromRect(item.frame)) } as! NSTextField
		
		label.stringValue = (item.controlState as? ButtonState)?.text ?? ""
		label.isBezeled = false
		label.drawsBackground = false
		label.isEditable = false
		label.isSelectable = false

		return label
	}
	
	open func renderSlider(_ item: Item) -> RenderedNode {
		let slider = viewForItem(item) { NSSlider(frame: CGRectFromRect(item.frame)) } as! NSSlider
		let state = item.controlState as? SliderState
	
		slider.minValue = Double(state?.minValue ?? 0)
		slider.maxValue = Double(state?.maxValue ?? 0)
		slider.objectValue = state?.initialValue ?? 0
		slider.setAction { [weak item = item] (sender: NSSlider) in item?.reactTo(sender) }

		if item.orientation == .horizontal {
			slider.frame.size.height = defaultSliderThickness
		}
		else {
			slider.frame.size.width = defaultSliderThickness
		}

		return slider
	}
	
	open func renderSwitch(_ item: Item) -> RenderedNode {
		let button = viewForItem(item) { NSButton(frame: CGRectFromRect(item.frame)) } as! NSButton
		
		button.frame.size.height = defaultSwitchHeight
		button.title = (item.controlState as? SwitchState)?.text ?? ""
		button.state = (item.controlState as? SwitchState)?.status.rawValue ?? 0
		button.setButtonType(.switch)
		button.setAction { [weak item = item] (sender: NSButton) in item?.reactTo(sender, isSwitch: true) }

		return button
	}
	
	// MARK: - Position and Size Constants
	
	var defaultSwitchHeight: CGFloat = 18
	var defaultSliderThickness: CGFloat = 21
	
	func reactToActionFrom(_ sender: NSObject) {
		
	}
}


// MARK: - Utilities

internal func RectFromCGRect(_ rect: CGRect) -> Rect {
	return Rect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
}

internal func CGRectFromRect(_ rect: Rect) -> CGRect {
	return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.extent.width, height: rect.extent.height)
}

// MARK: - Rendered Nodes

extension NSView: RendererDestination, RenderedNode {

	internal var confettiFrame: Rect {
		get {
			if let superview = superview , superview.isFlipped == false {
				var rect = frame
				rect.origin.y = superview.frame.size.height - frame.maxY
				return RectFromCGRect(rect)
			}
			else {
				return RectFromCGRect(frame)
			}
		}
		set {
			if let superview = superview , superview.isFlipped == false {
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
				return RectFromCGRect(contentRect(forFrameRect: rect))
			}
			else {
				return RectFromCGRect(contentRect(forFrameRect: frame))
			}
		}
		set {
			if let screen = screen {
				var rect = frameRect(forContentRect: CGRectFromRect(newValue))
				rect.origin.y = screen.visibleFrame.size.height - rect.maxY
				setFrame(rect, display: false)
			}
			else {
				setFrame(frameRect(forContentRect: CGRectFromRect(newValue)), display: false)
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
