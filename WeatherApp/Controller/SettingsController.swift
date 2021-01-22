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
    
    private let checkedImage   = UIImage(systemName: "checkmark.circle.fill")
    private let uncheckedImage = UIImage(systemName: "circle")
    
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
        kmhImageView.image = checkedImage
        msImageView.image  = uncheckedImage
        mphImageView.image = uncheckedImage
        
        checkedSpeed = Constants.Speed.kmh.rawValue
    }
    
    @IBAction func msClicked() {
        kmhImageView.image = uncheckedImage
        msImageView.image  = checkedImage
        mphImageView.image = uncheckedImage
        
        checkedSpeed = Constants.Speed.ms.rawValue
    }
    
    @IBAction func mphClicked() {
        kmhImageView.image = uncheckedImage
        msImageView.image  = uncheckedImage
        mphImageView.image = checkedImage
        
        checkedSpeed = Constants.Speed.mph.rawValue
    }
    
    @IBAction func celsiusClicked() {
        celsiusImageView.image    = checkedImage
        fahrenheitImageView.image = uncheckedImage
        kelvinImageView.image     = uncheckedImage
        
        checkedTemperature = Constants.Temperature.celsius.rawValue
    }
    
    @IBAction func fahrenheitClicked() {
        celsiusImageView.image    = uncheckedImage
        fahrenheitImageView.image = checkedImage
        kelvinImageView.image     = uncheckedImage
        
        checkedTemperature = Constants.Temperature.fahrenheit.rawValue
    }
    
    @IBAction func kelvinClicked() {
        celsiusImageView.image    = uncheckedImage
        fahrenheitImageView.image = uncheckedImage
        kelvinImageView.image     = checkedImage
        
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
