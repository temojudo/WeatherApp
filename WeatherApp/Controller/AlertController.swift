//
//  AlertController.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/18/21.
//

import UIKit

protocol AddCityDelegate: AnyObject {
    func cityAddedSuccessfully(_ sender: AlertController, response: CurrentWeatherResponse)
}

class AlertController: UIViewController {
    
    @IBOutlet private var backgroundImageView:   UIImageView!
    @IBOutlet private var popupView:             UIView!
    @IBOutlet private var submitButtonImageView: UIImageView!
    @IBOutlet private var textField:             UITextField!
    @IBOutlet private var addButtonLoader:       UIActivityIndicatorView!
    @IBOutlet private var errorAlertView:        UIView!
    
    weak var delegate: AddCityDelegate?
    
    private let service = CurrentWeatherService()
    
//    override var shouldAutorotate: Bool
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius      = 25
        errorAlertView.layer.cornerRadius = 15
        
        errorAlertView.isHidden = true
//        shouldAutorotate = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != popupView {
            dismissViewController()
        }
    }
    
    func dismissViewController() {
//        shouldAutorotate = true
        dismiss(animated: true, completion: nil)
    }
    
    func setBackgroundImage(image: UIImage?) {
        backgroundImageView.image = image
        backgroundImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    @IBAction func submit() {
        guard let city = textField.text, !city.isEmpty else { return }
        
        addButtonLoader.startAnimating()
        submitButtonImageView.isHidden = true
        service.loadCurrentWeatherResponce(for: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async() {
                self.addButtonLoader.stopAnimating()
                self.submitButtonImageView.isHidden = false
                switch result {
                    case .success(let weatherResponse):
                        self.delegate?.cityAddedSuccessfully(self, response: weatherResponse)
                        self.dismissViewController()

                    case .failure(let error):
                        print(error)
                        self.errorAlertView.isHidden = false
//                        self.dismissViewController()
                }
            }
        }
        
    }
    
}
