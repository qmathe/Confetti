//
//  AppKitRunner.swift
//  Confetti
//
//  Created by Quentin Mathé on 06/08/2017.
//  Copyright © 2017 Quentin Mathé. All rights reserved.
//

import Foundation
import AppKit

private var app: App!

// MARK: - Launching

public func run(_ presentation: Presentation, with renderer: Renderer = AppKitRenderer()) {
	app = App(presentation: presentation, renderer: renderer)
	_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

// MARK: - Confetti AppKit Application

@objc(ConfettiApplication) public class ConfettiApplication: NSApplication {

	override public func sendEvent(_ event: NSEvent) {
		super.sendEvent(event)
		app.update()
	}
}
