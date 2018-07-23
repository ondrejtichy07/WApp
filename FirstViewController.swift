//
//  FirstViewController.swift
//  WApp
//
//  Created by Ondřej on 22/07/2018.
//  Copyright © 2018 Ondřej Tichý. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController, CLLocationManagerDelegate, changeCityDelegate {
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    func getWeatherData (url: String, parameters: [String : String])
    {
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON
            {
                response in
                if response.result.isSuccess
                {
                    print("Success! got the weather data")
                    let weatherJSON : JSON = JSON(response.result.value!)
                    self.updateWeatherData(json: weatherJSON)
                }
                else
                {
                    print ("Error \(String(describing: response.result.error ?? nil))")
                    self.cityLabel.text = "Connection issues"
                }
        }
    }
    
    
    func updateWeatherData (json: JSON)
    {
        if let tempResult = json["main"]["temp"].double
        {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWeatherData()
        }
        else
        {
            cityLabel.text = "Weather  Unavailable"
        }
    }
    
    
    func updateUIWeatherData()
    {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature) + "°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0
        {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters : params)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "City location unavailable"
    }
    
    
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"
        {
            let destinationVC = segue.destination as! SecondViewController
            
            destinationVC.delegate = self
        }
    }
    
    
}
