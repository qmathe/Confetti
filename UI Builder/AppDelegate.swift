//
//  AppDelegate.swift
//  UI Builder
//
//  Created by Quentin Mathé on 01/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Cocoa
import Tapestry
import Confetti

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, EventReceiver {

	let renderer = AppKitRenderer()
	var window: NSWindow!
	var objectGraph = ObjectGraph()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let ui = UI(objectGraph: objectGraph)
		let button = ui.button(frame: Rect(x: 0, y: 0, width: 400, height: 200), text: "OK")
		let otherButton = ui.button(frame: Rect(x: 0, y: 0, width: 400, height: 200), text: "Cancel")
		let slider = ui.slider(orientation: .horizontal, origin: Point(x: 400, y: 200), length: 400, max: 100, initial: 50)
		let subitem = ui.item(frame: Rect(x: 1000, y: 200, width: 1000, height: 400), items: [])
		let item = ui.item(frame: Rect(x: 200, y: 200, width: 1000, height: 400), items: [button, subitem])

		item.eventCenter.add(EventHandler<Tap>(selector: "tap", receiver: self, sender: button))

		item.render(renderer)
		
		/*let styleMask: Int = NSBorderlessWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask | NSUnifiedTitleAndToolbarWindowMask
		window = NSWindow(contentRect: CGRect(x: 200, y: 200, width: 1000, height: 400), styleMask: styleMask, backing: .Buffered, defer: false)
		
		window.title = "Whatever"
		window.contentView = NSButton(frame: CGRect(x: 200, y: 200, width: 1000, height: 400))
		window.makeKeyAndOrderFront(nil)*/
	}
	
	func eventHandlerInvocationFor(_ selector: FunctionIdentifier) -> AnyEventHandlerInvocation? {
		switch selector {
			case "tap": return EventHandlerInvocation<Tap, AppDelegate>(function: AppDelegate.tap(event:))
			default: return nil
		}
	}
	
	func tap(event: Event<Tap>) {
		print("Tap")
	}
}
