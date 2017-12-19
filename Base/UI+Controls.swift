/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import RxSwift
import Tapestry

// TODO: Make frame arguments optional once we support Item.sizeToFit()
public extension UI {

	public func label(frame: Rect, text: String = "") -> Item {
		let item = Item(frame: frame, objectGraph: objectGraph)
	
		item.styles = [LabelStyle(objectGraph: objectGraph)]
		item.controlState = LabelState(text: text, objectGraph: objectGraph)
		
		return item
	}
	
	public func label(extent: Extent, text: String = "") -> Item {
		return label(frame: Rect(origin: Point(x: 0, y: 0), extent: extent), text: text)
	}
	
	public func button(frame: Rect, text: String, tap bindTap: (Observable<Tap>, Item) -> ()) -> Item {
		let item = Item(frame: frame, objectGraph: objectGraph)
        let state = ButtonState(text: text, objectGraph: objectGraph)

		item.styles = [ButtonStyle(objectGraph: objectGraph)]
		item.controlState = state
        bindTap(state.tap.asObservable(), item)

		return item
	}

	public func button(extent: Extent, text: String = "", tap bindTap: (Observable<Tap>, Item) -> ()) -> Item {
        return button(frame: Rect(origin: Point(x: 0, y: 0), extent: extent), text: text, tap: bindTap)
	}

    public func button(extent: Extent, text: String = "", tap tapAction: @escaping (Tap) -> ()) -> Item {
        return button(frame: Rect(origin: Point(x: 0, y: 0), extent: extent), text: text, tap: bind(to: tapAction))
    }

    public func button(extent: Extent, text: String = "", tap tapAction: @escaping () -> ()) -> Item {
        return button(frame: Rect(origin: Point(x: 0, y: 0), extent: extent), text: text, tap: bind(to: tapAction))
    }

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
    public func `switch`(frame: Rect, text: String = "", status: SwitchStatus = .off, tap bindStatus: (Observable<SwitchStatus>, Item) -> (), forProperty property: String = "", ofRepresentedObject representedObject: AnyObject? = nil) -> Item {
		let item = Item(frame: frame, objectGraph: objectGraph)
        let state = SwitchState(text: text, status: status, objectGraph: objectGraph)

		item.styles = [SwitchStyle(objectGraph: objectGraph)]
		item.controlState = state
		item.representedObject = representedObject
        
        bindStatus(state.status.asObservable(), item)
		
		return item
	}
	
	public func slider(orientation: Orientation, origin: Point, length: VectorFloat, min: VectorFloat = 0, max: VectorFloat, initial: VectorFloat,
                       pan bindValue: (Observable<VectorFloat>, Item) -> (), forProperty property: String = "", ofRepresentedObject representedObject: AnyObject? = nil) -> Item {
	
		let width = orientation == .horizontal ? length : SliderStyle.defaultHeight
		let height = orientation == .horizontal ? SliderStyle.defaultHeight : length

		let item = Item(frame: Rect(x: origin.x, y: origin.y, width: width, height: height), objectGraph: objectGraph)
        let state = SliderState(min: min, max: max, initial: initial, objectGraph: objectGraph)

		item.styles = [SliderStyle(objectGraph: objectGraph)]
		item.controlState = SliderState(min: min, max: max, initial: initial, objectGraph: objectGraph)
		item.representedObject = representedObject
        
        bindValue(state.currentValue.asObservable(), item)
		
		return item
	}

    // MARK: - Binding Observable to Action

    private func bind<E>(to action: @escaping (E) -> ()) -> ((Observable<E>, Item) -> ()) {
        return { observable, _ in
            observable.bind(to: action).disposed(by: self.bag)
        }
    }

    private func bind<E>(to action: @escaping () -> ()) -> ((Observable<E>, Item) -> ()) {
        return { observable, _ in
            observable.bind(to: action).disposed(by: self.bag)
        }
    }
}
