//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Эллаиса Даценко on 21.11.2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
//    let time: String
//    let asset_id_base: String
//    let asset_id_quote: String
    let rate: Double
    
    var rateString: String{
        return (String(format: "%.2f", rate))
    }
}
