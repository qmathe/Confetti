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

// MARK: - Confetti Application Delegate

public class AppDelegate: NSObject, NSApplicationDelegate {

	public func applicationDidFinishLaunching(_ notification: Notification) {
		app.update()
	}
}
