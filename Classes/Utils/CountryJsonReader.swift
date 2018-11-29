//
//  CountryJsonReader.swift
//  CountryPicker
//
//  Created by Michael Rothkegel on 01.10.18.
//  Copyright © 2018 Michael Rothkegel. All rights reserved.
//

import Foundation


class CountryJsonReader {
    
    // MARK: PRIVATES
    private static func parseFileToData(path: String) -> Data? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    private static func parseCountryHolderWith(data: Data) -> CountryHolder? {
        do {
            let parsedJson = try JSONDecoder().decode(CountryHolder.self, from: data)
            return parsedJson
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: PUBLIC
    static func getCountryRessource(name: String) -> CountryHolder? {
        
        let resource = "Data" + ".bundle" + "/" + name
        
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            print("path could not found")
            return nil
        }
        
        guard let data = parseFileToData(path: path) else {
            print("Data could not parse to json")
            return nil
        }
        
        guard let parsedCountryHolder = parseCountryHolderWith(data: data) else {
            print("Can't parsed country holder ressource")
            return nil
        }
        
        return parsedCountryHolder
    }
}
