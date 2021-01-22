//
//  SettingsController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/22/21.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func settingsChanged(_ sender: SettingsController)
}

class SettingsController: UIViewController {
    
    @IBOutlet private var saveButton:          UIButton!
    @IBOutlet private var cancelButton:        UIButton!
    @IBOutlet private var kmhImageView:        UIImageView!
    @IBOutlet private var msImageView:         UIImageView!
    @IBOutlet private var mphImageView:        UIImageView!
    @IBOutlet private var celsiusImageView:    UIImageView!
    @IBOutlet private var fahrenheitImageView: UIImageView!
    @IBOutlet private var kelvinImageView:     UIImageView!
    
    private var checkedTemperature = 0
    private var checkedSpeed       = 0
    
    private var initTemperatureSystem = 0
    private var initSpeedSystem       = 0
    
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCornerRadius()
        setupImages()
    }
    
    private func setupCornerRadius() {
        saveButton.layer.cornerRadius   = 15
        cancelButton.layer.cornerRadius = 15
    }
    
    private func setupImages() {
        initTemperatureSystem = UserDefaults.standard.object(forKey: Constants.temperatureKey) as? Int ?? Constants.Speed.kmh.rawValue
        initSpeedSystem       = UserDefaults.standard.object(forKey: Constants.speedKey)       as? Int ?? Constants.Temperature.celsius.rawValue
        
        switch (initTemperatureSystem) {
            case Constants.Temperature.celsius.rawValue:
                celsiusClicked()
                break
                
            case Constants.Temperature.fahrenheit.rawValue:
                fahrenheitClicked()
                break
                
            case Constants.Temperature.kelvin.rawValue:
                kelvinClicked()
                break
                
            default:
                break
        }
        
        switch (initSpeedSystem) {
            case Constants.Speed.kmh.rawValue:
                kmhClicked()
                break
                
            case Constants.Speed.ms.rawValue:
                msClicked()
                break
                
            case Constants.Speed.mph.rawValue:
                mphClicked()
                break
                
            default:
                break
        }
    }
    
    @IBAction func kmhClicked() {
        kmhImageView.image = Constants.checkedImage
        msImageView.image  = Constants.uncheckedImage
        mphImageView.image = Constants.uncheckedImage
        
        checkedSpeed = Constants.Speed.kmh.rawValue
    }
    
    @IBAction func msClicked() {
        kmhImageView.image = Constants.uncheckedImage
        msImageView.image  = Constants.checkedImage
        mphImageView.image = Constants.uncheckedImage
        
        checkedSpeed = Constants.Speed.ms.rawValue
    }
    
    @IBAction func mphClicked() {
        kmhImageView.image = Constants.uncheckedImage
        msImageView.image  = Constants.uncheckedImage
        mphImageView.image = Constants.checkedImage
        
        checkedSpeed = Constants.Speed.mph.rawValue
    }
    
    @IBAction func celsiusClicked() {
        celsiusImageView.image    = Constants.checkedImage
        fahrenheitImageView.image = Constants.uncheckedImage
        kelvinImageView.image     = Constants.uncheckedImage
        
        checkedTemperature = Constants.Temperature.celsius.rawValue
    }
    
    @IBAction func fahrenheitClicked() {
        celsiusImageView.image    = Constants.uncheckedImage
        fahrenheitImageView.image = Constants.checkedImage
        kelvinImageView.image     = Constants.uncheckedImage
        
        checkedTemperature = Constants.Temperature.fahrenheit.rawValue
    }
    
    @IBAction func kelvinClicked() {
        celsiusImageView.image    = Constants.uncheckedImage
        fahrenheitImageView.image = Constants.uncheckedImage
        kelvinImageView.image     = Constants.checkedImage
        
        checkedTemperature = Constants.Temperature.kelvin.rawValue
    }
    
    @IBAction func save() {
        UserDefaults.standard.set(checkedSpeed,       forKey: Constants.speedKey)
        UserDefaults.standard.set(checkedTemperature, forKey: Constants.temperatureKey)
        
        if checkedSpeed != initSpeedSystem || checkedTemperature != initTemperatureSystem {
            self.delegate?.settingsChanged(self)
        }
        
        cancel()
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
