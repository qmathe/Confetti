//
//  Item.swift
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation


class Item {

	var identifier: String?
	var representedObject: Any
	var geometry: Any
	// For 2D, there is style.backgroundStyles and style.foregroundStyles
	var style: Any
	var layout: Any
	var items: [Item]?
	var isGroup: Bool { return items != nil }
	var hidden = false

}