//
//  SecondViewController.swift
//  WApp
//
//  Created by Ondřej on 22/07/2018.
//  Copyright © 2018 Ondřej Tichý. All rights reserved.
//

import UIKit

protocol changeCityDelegate {
    func userEnteredANewCityName (city: String)
}

class SecondViewController: UIViewController {

    var delegate : changeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityName(city: cityName)
        self.navigationController?.popViewController(animated: true)
        
    }
}
