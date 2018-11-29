//
//  CountryPickerTool.swift
//  CountryPicker
//
//  Created by Michael Rothkegel on 01.10.18.
//  Copyright © 2018 Michael Rothkegel. All rights reserved.
//

import Foundation
import UIKit


class CountryPickerHelper {
    var countryHolder = CountryHolder()

    init(countryCode: String, sortType: SortType = .country) {
        if let countryHolder = CountryJsonReader.getCountryRessource(name: "countries_\(countryCode.uppercased())") {
            self.countryHolder = countryHolder
        } else {
            //language not found - take default
            if let countryHolder = CountryJsonReader.getCountryRessource(name: "countries_US") {
                self.countryHolder = countryHolder
            }
        }
        
        for country in countryHolder.countries {
            if let dialCodeToNumber = Int(country.dial_code.replacingOccurrences(of: "+", with: "")) {
                country.dialCodeAsNumber = dialCodeToNumber
            }
        }
        
        if sortType == .dialCode {
            countryHolder.countries.sort(by: { ($0.dialCodeAsNumber ?? 0) < ($1.dialCodeAsNumber ?? 1) } )
        } else {
            countryHolder.countries.sort(by: { $0.name < $1.name })
        }
    }
    
    
    /*
     input: Germany
     response: Country { Germany, DE, +49}
     */
    func getCountryBy(countryName: String) -> Country? {
        guard let country = countryHolder.countries.first(where: {( $0.name == countryName )}) else {
            return nil
        }
        return country
    }
    
    /**
     input: de, DE
     response: Country { Germany, DE, +49}
     */
    func getCountryBy(countryCode: String) -> Country? {
        guard let country = countryHolder.countries.first(where: {( $0.code == countryCode.uppercased() )}) else {
            return nil
        }
        return country
    }
    
    /**
     input: +49 or 49
     response: Country { Germany, DE, +49}
     */
    func getCountryBy(dialCode: String) -> Country? {
        var mDialCode = dialCode
        if !dialCode.hasPrefix("+") {
            mDialCode = "+\(dialCode)"
        }
        guard let country = countryHolder.countries.first(where: {( $0.dial_code == mDialCode )}) else {
            return nil
        }
        return country
    }
}
