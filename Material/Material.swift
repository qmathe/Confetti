//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

public class Material {

}

public class StyleMaterial: Material {
	public var styles: [Style]
	
	public init(styles: [Style]) {
		self.styles = styles
	}
}
