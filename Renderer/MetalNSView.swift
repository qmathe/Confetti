//
//  MetalRenderer.swift
//  Confetti
//
//  Created by Quentin Mathé on 01/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore
import MetalKit

class MetalNSView: NSView {

	var renderer = MetalRenderer()
	var displayLink: CVDisplayLink?
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setUp()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setUp()
	}
	
	override func makeBackingLayer() -> CALayer {
		return CAMetalLayer()
	}
	
	func setUp() {
		layer = makeBackingLayer()
		
		guard let layer = layer as? CAMetalLayer else {
			fatalError("Missing metal layer")
		}

		layer.device = renderer.device
		layer.pixelFormat = .BGRA8Unorm
		layer.framebufferOnly = true
		layer.frame = frame

    	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
    	CVDisplayLinkSetOutputCallback(displayLink!, render, UnsafeMutablePointer(unsafeAddressOf(self)))
    	CVDisplayLinkStart(displayLink!);
	}
	
	deinit {
		if let displayLink = displayLink {
			CVDisplayLinkStop(displayLink)
		}
	}
}

private func render(displayLink: CVDisplayLink,
                            now: UnsafePointer<CVTimeStamp>,
                     outputTime: UnsafePointer<CVTimeStamp>,
                        flagsIn: CVOptionFlags,
                       flagsOut: UnsafeMutablePointer<CVOptionFlags>,
             displayLinkContext: UnsafeMutablePointer<Void>) -> CVReturn {
	let view = unsafeBitCast(displayLinkContext, MetalNSView.self)
	
	guard let layer = view.layer as? CAMetalLayer,
	          drawable = layer.nextDrawable() else {
		return kCVReturnError
	}
	view.renderer.renderItem(nil, intoDrawable: drawable)
	return kCVReturnSuccess
}
