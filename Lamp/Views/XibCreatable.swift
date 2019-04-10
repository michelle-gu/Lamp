//
//  XibCreatable.swift
//  Lamp
//
//  Created by Maria Ocanas on 4/9/19.
//  Copyright © 2019 LaMMP. All rights reserved.
//

import Foundation
import UIKit

protocol XibCreatable {
    static func create() -> Self
}

extension XibCreatable where Self: UIView {
    static func create() -> Self {
        let dynamicMetatype = Self.self
        let bundle = Bundle(for: dynamicMetatype)
        let nib = UINib(nibName: "\(dynamicMetatype)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}
