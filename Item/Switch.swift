/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public enum SwitchState: Int {
	case On
	case Off
	case None
}

public class Switch: Item {

	public var text = ""
	public var state = SwitchState.Off

	// TODO: Make frame optional once we support sizeToFit()
	
	/**
	Returns a toggle button that will be rendered either as a switch or checkbox.
	
	You can provide a model on which setValue(:forProperty:) will be called
	for the property every time the state changes.
	
	The model object and property name are used to initialize a property viewpoint
	which is set as the returned item represented object. The property view point
	is also initialized to treat dictionary keys as properties, so you can use a
	dictionary as model.
	
	Note: Reading/writing a property is not yet implemented.
	*/
	public init(frame: Rect, text: String = "", state: SwitchState = .Off, target: AnyObject? = nil,
		action: Selector? = nil, forProperty property: String = "", ofRepresentedObject representedObject: AnyObject? = nil) {

		super.init(frame: frame)

		// TODO: Support target/action and property according to documentation
		self.text = text
		self.state = state
		self.representedObject = representedObject
	}

	public override func render(renderer: Renderer) -> RenderedNode {
		return renderer.renderSwitch(self)
	}
	
	// MARK: - Actions

	/// Updates the current state and emits a SwitchState event.
	///
	/// Will be called when the switch is clicked or swiped.
	dynamic func toggle(toState: Int) {
		state = SwitchState(rawValue: toState)!
		eventCenter.send(state, from: self)
	}
}
