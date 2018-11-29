//
//  Country.swift
//  CountryPicker
//
//  Created by Michael Rothkegel on 01.10.18.
//  Copyright © 2018 Michael Rothkegel. All rights reserved.
//

import Foundation
class Country: Codable {
    var name: String
    var dial_code: String
    var code: String
    var dialCodeAsNumber: Int?
}
