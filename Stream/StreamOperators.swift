/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  June 2017
	License:  MIT
 */

import Foundation
import Dispatch

extension Stream {

	open func delay(_ seconds: TimeInterval) -> Stream<T> {
		let stream = Stream()

		_ = subscribe(stream) { event in
			switch event {
			case .error(_):
				stream.append(event)
			default:
				stream.queue.asyncAfter(deadline: .now() + seconds) {
					stream.append(event)
				}
			}
		}
		return stream
	}
}
