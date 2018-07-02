//
//  ImageData.swift
//  NoteTaking
//
//  Created by Shumaz Ahamed Junaidi on 12/6/17.
//  Copyright © 2017 ShumazAhamedJunaidi. All rights reserved.
//


import UIKit

public class ImageData {
    
    var imgData: UIImage
    var long: Double
    var lat: Double
    init(_ image:UIImage, _ longitude:Double, _ latitute:Double) {
        imgData = image
        long = longitude
        lat = latitute
    }
    
}
