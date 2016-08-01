//
//  MetalRenderer.swift
//  Confetti
//
//  Created by Quentin Mathé on 01/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation
import MetalKit

class MetalRenderer {

	let device = MTLCreateSystemDefaultDevice()!
	let commandQueue: MTLCommandQueue
	let pipelineDescriptor = MTLRenderPipelineDescriptor()
	let pipelineState: MTLRenderPipelineState
	let library: MTLLibrary
	let fragmentProgram: MTLFunction
	let vertexProgram: MTLFunction
	var vertexBuffer: MTLBuffer?

	init() {
		commandQueue = device.newCommandQueue()

		let libFile = NSBundle(forClass: self.dynamicType).pathForResource("default", ofType: "metallib")!

		library = try! device.newLibraryWithFile(libFile)
		fragmentProgram = library.newFunctionWithName("basic_fragment")!
		vertexProgram = library.newFunctionWithName("basic_vertex")!

		pipelineDescriptor.vertexFunction = vertexProgram
		pipelineDescriptor.fragmentFunction = fragmentProgram
		pipelineDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		pipelineState = try! device.newRenderPipelineStateWithDescriptor(pipelineDescriptor)
	}
	
	func renderItem(item: Item?, intoDrawable drawable: CAMetalDrawable) {
		let commandBuffer = commandQueue.commandBuffer()

		let vertexData:[Float] = [0.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0, -1.0, 0.0]
		let dataSize = vertexData.count * sizeofValue(vertexData[0])

		vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: .OptionCPUCacheModeDefault)
		
		let renderDescriptor = MTLRenderPassDescriptor()

		renderDescriptor.colorAttachments[0].texture = drawable.texture
		renderDescriptor.colorAttachments[0].loadAction = .Clear
		renderDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)

		let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderDescriptor)

		renderEncoder.setRenderPipelineState(pipelineState)
  		renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
		renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
  		renderEncoder.endEncoding()
		
		commandBuffer.presentDrawable(drawable)
		commandBuffer.commit()
	}
}

