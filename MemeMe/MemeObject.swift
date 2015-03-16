//
//  MemeObject.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 11/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import Foundation
import UIKit

class MemeObject: NSObject {

    var topText: String = ""
    var bottomText: String = ""
    var originalImage: UIImage? = nil
    var memedImage: UIImage? = nil
    
    convenience init(topText: String, bottomText: String, originalImage:UIImage, memedImage: UIImage) {
        self.init()
        updateMeme(topText, bottomText: bottomText, originalImage: originalImage, memedImage: memedImage)
    }
    
    func updateMeme(topText: String, bottomText: String, originalImage:UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
