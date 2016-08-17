//
//  AppDelegate.swift
//  UI Builder
//
//  Created by Quentin Mathé on 01/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Cocoa
import Confetti

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, EventReceiver {

	let renderer = AppKitRenderer()
	var window: NSWindow!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let button = Button(frame: Rect(x: 0, y: 0, width: 400, height: 200), text: "OK")
		let item = Item(frame: Rect(x: 200, y: 200, width: 1000, height: 400))

		item.eventCenter.add(EventHandler<Tap, AppDelegate>(selector: "tap", receiver: self, sender: button))
		item.items = [button]

		item.render(renderer)
		
		/*let styleMask: Int = NSBorderlessWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask | NSUnifiedTitleAndToolbarWindowMask
		window = NSWindow(contentRect: CGRect(x: 200, y: 200, width: 1000, height: 400), styleMask: styleMask, backing: .Buffered, defer: false)
		
		window.title = "Whatever"
		window.contentView = NSButton(frame: CGRect(x: 200, y: 200, width: 1000, height: 400))
		window.makeKeyAndOrderFront(nil)*/
	}
	
	func eventHandlerFunctionFor(selector: FunctionIdentifier) -> AnyEventHandlerFunction? {
		switch selector {
			case "tap": return unsafeBitCast(AppDelegate.tap(_:), AnyEventHandlerFunction.self)
			default: return nil
		}
	}
	
	func tap(event: Event<Tap>) {
		print("Tap")
	}
}
