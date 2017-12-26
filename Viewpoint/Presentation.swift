/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift

public protocol Presentation: class {
	var presentations: [Presentation] { get }
	var changed: Observable<Void> { get }
	var item: Observable<Item> { get }

    func clear()
}
