//
//  DotView.swift
//  DiceMVVM
//
//  Created by Drew Milloy on 18/07/2019.
//  Copyright © 2019 Marmadore Studio. All rights reserved.
//

import UIKit

class DotView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.size.width / 2
    }
}
