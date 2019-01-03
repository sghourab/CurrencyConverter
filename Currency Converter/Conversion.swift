//
//  Conversion.swift
//  Currency Converter
//
//  Created by Summer Crow on 07/11/2018.
//  Copyright © 2018 ghourab. All rights reserved.
//

import Foundation
import UIKit

class Conversion {
    
    var currencyFromRate: Double
    var currencyToRate: Double
    
    
    init(currencyFromRate: Double, currencyToRate: Double, value: Double){
        self.currencyFromRate = currencyFromRate
        self.currencyToRate = currencyToRate
    }
    
    func convert (value: Double) -> Double{
        let valueOfCurrencyFrom = value / currencyFromRate
        let valueOfCurrencyTo = valueOfCurrencyFrom * currencyToRate
        return valueOfCurrencyTo
    
    }
}
