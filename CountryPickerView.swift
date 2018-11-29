//
//  CountryPickerView.swift
//  CountryPicker
//
//  Created by Michael Rothkegel on 01.10.18.
//  Copyright © 2018 Michael Rothkegel. All rights reserved.
//

import UIKit

enum SortType {
    case dialCode, country
}

class CountryPickerView: UIPickerView {
    typealias CountryCode = String
    
    convenience init(countryCode: CountryCode, configuration: CountryPickerViewConfiguration, sortType: SortType) {
        self.init()
        self.configuration = configuration
        countryPickerHelper = CountryPickerHelper(countryCode: countryCode, sortType: sortType)
        delegate = self
        dataSource = self
        
        if let row = countryPickerHelper?.countryHolder.countries.firstIndex(where: { $0.code == countryCode.uppercased()}) {
            
            if let countryPickerHelper = countryPickerHelper {
                if row < countryPickerHelper.countryHolder.countries.count {
                    self.selectRow(row, inComponent: 0, animated: true)
                }
            }

            guard let country = countryPickerHelper?.countryHolder.countries[row] else {
                return
            }
            currentCountry = country
            currentCountryFlagImage = getFlag(for: countryCode)
        }
    }
    
    private let imagePath = "Media.bundle"
    private var imageCache = NSCache<NSString, UIImage>()
    
    var configuration: CountryPickerViewConfiguration?
    var countryPickerHelper: CountryPickerHelper?
    var currentCountryFlagImage: UIImage?
    var currentCountry: Country?
    
    //callback
    var pickedCountry: ((_ country: Country, _ flag: UIImage?) -> Void)?
    
    
    func fillCacheWithImages() {
        guard let isFlagVisible = self.configuration?.isFlagVisible else {
            return
        }
        
        guard let countries = self.countryPickerHelper?.countryHolder.countries else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if isFlagVisible {
                for country in countries {
                    let imagename = self.imagePath + "/" + country.code
                    if let image = UIImage(named: imagename)   {
                        self.imageCache.setObject(image, forKey: country.code as NSString)
                    }
                }
            }
        }
    }
    
    private func getFlag(for countryCode: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: countryCode as NSString) {
            return cachedImage
        }
        let imagename = imagePath + "/" + countryCode
        guard let image = UIImage(named: imagename) else {
            return nil
        }
        imageCache.setObject(image, forKey: countryCode as NSString)
        return image
    }
}

extension CountryPickerView : UIPickerViewDataSource, UIPickerViewDelegate {
    
    //columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryPickerHelper?.countryHolder.countries.count ?? 0
    }


//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let countryHolderView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
//
//        guard let country = countryPickerHelper?.countryHolder.countries[row] else {
//            return countryHolderView
//        }
//
//        guard let configuration = self.configuration else {
//            return countryHolderView
//        }
//
//
//        let flagImageView = UIImageView(frame: CGRect(x: 16, y: 0, width: 30, height: 22.5))
//        flagImageView.image = getFlag(for: country.code)
//        flagImageView.contentMode = .scaleAspectFit
//
//        let countryNameLabel = UILabel(frame: CGRect(x: 35+16, y: 0, width: self.frame.width-30-35-16, height: 30))
//        countryNameLabel.text = country.name
//        countryNameLabel.textAlignment = .center
//
//        countryHolderView.addSubview(flagImageView)
//        countryHolderView.addSubview(countryNameLabel)
//        return countryHolderView
//    }
    
   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let country = countryPickerHelper?.countryHolder.countries[row] else {
            return NSAttributedString(string: "")
        }
        
        guard let configuration = self.configuration else {
            return NSAttributedString(string: "")
        }
        
        let response = NSMutableAttributedString(string: "")
        
        if configuration.isFlagVisible {
            let flagImageAttachment = NSTextAttachment()
            flagImageAttachment.image = getFlag(for: country.code)
            flagImageAttachment.bounds = CGRect(x: 0, y: -3, width: 30, height: 22.5)
            
            let wrappedImage = NSAttributedString(attachment: flagImageAttachment)
            
            response.append(wrappedImage)
            response.append(NSAttributedString(string: " "))
        }
        
        if configuration.isCountryDialCodeVisible {
            response.append(NSAttributedString(string: country.dial_code + " "))
        }
        
        if configuration.isCountryCodeVisible {
            response.append(NSAttributedString(string: country.code + " "))
        }
        
        if configuration.isCountryNameVisible {
            response.append(NSAttributedString(string: country.name + " "))
        }
        
        return response
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let country = countryPickerHelper?.countryHolder.countries[row] else {
            return
        }
        currentCountry = country
        
        let image = getFlag(for: country.code)
        currentCountryFlagImage = image
        
        pickedCountry?(country,image)
    }
}
