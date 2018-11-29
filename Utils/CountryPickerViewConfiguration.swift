//
//  CountryPickerViewConfiguration.swift
//  SMASUserAppIOS
//
//  Created by Michael Rothkegel on 08.10.18.
//  Copyright © 2018 Michael Rothkegel. All rights reserved.
//

import Foundation


class CountryPickerViewConfiguration {
    var isFlagVisible = false
    var isCountryCodeVisible = false
    var isCountryNameVisible = false
    var isCountryDialCodeVisible = false
    
    private init() {}
    
    init(isFlagVisible: Bool) {
        self.isFlagVisible = isFlagVisible
    }
    
    init(isFlagVisible: Bool, isCountryCodeVisible: Bool) {
        self.isFlagVisible = isFlagVisible
        self.isCountryCodeVisible = isCountryCodeVisible
    }
    
    init(isFlagVisible: Bool, isCountryCodeVisible: Bool, isCountryNameVisible: Bool) {
        self.isFlagVisible = isFlagVisible
        self.isCountryCodeVisible = isCountryCodeVisible
        self.isCountryNameVisible = isCountryNameVisible
    }
    
    init(isFlagVisible: Bool, isCountryCodeVisible: Bool, isCountryNameVisible: Bool, isCountryDialCodeVisible: Bool) {
        self.isFlagVisible = isFlagVisible
        self.isCountryCodeVisible = isCountryCodeVisible
        self.isCountryNameVisible = isCountryNameVisible
        self.isCountryDialCodeVisible = isCountryDialCodeVisible
    }
}

