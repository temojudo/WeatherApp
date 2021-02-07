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
    @IBOutlet private var contentView:           UIView!
    @IBOutlet private var errorStackView:        UIView!
    
    private let service = WeatherService()
    
    weak var delegate: AddCityDelegate?
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addKeyboardNotifications()
    }
    
    private func setupViews() {
        popupView.layer.cornerRadius      = 25
        errorAlertView.layer.cornerRadius = 15
        
        errorAlertView.isHidden = true
        textField.delegate = self
        
        contentView.frame = view.bounds
        view.addSubview(contentView)
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardShow(notification:)),
            name: UIApplication.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardHide(notification:)),
            name: UIApplication.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        
        let diff = endFrame.cgRectValue.minY - popupView.frame.maxY
        if diff < 0 {
            UIView.animate(
                withDuration: duration,
                animations: {
                    self.contentView.frame = self.contentView.frame.offsetBy(dx: 0, dy: diff)
                }
            )
        }
        
    }
    
    @objc func handleKeyboardHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        UIView.animate(
            withDuration: duration,
            animations: {
                self.contentView.frame = self.view.bounds
            }
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != popupView && touch?.view != errorAlertView && touch?.view != errorStackView {
            dismiss(animated: true, completion: nil)
        } else if touch?.view == popupView && touch?.view != submitButtonImageView && touch?.view != textField {
            textField.resignFirstResponder()
        }
    }
    
    func setBackgroundImage(image: UIImage?) {
        backgroundImageView.image     = image
        backgroundImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    @IBAction func submit() {
        textField.resignFirstResponder()
        
        guard let city = textField.text, !city.isEmpty else { return }
        
        addButtonLoader.startAnimating()
        submitButtonImageView.isHidden = true
        service.loadCurrentWeatherResponce(city: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async() {
                self.addButtonLoader.stopAnimating()
                self.submitButtonImageView.isHidden = false
                switch result {
                    case .success(let weatherResponse):
                        self.delegate?.cityAddedSuccessfully(self, response: weatherResponse)
                        self.dismiss(animated: true, completion: nil)

                    case .failure( _):
                        self.textField.text = ""
                        self.errorAlertView.isHidden = false
                }
            }
        }
    }
    
}

extension AlertController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
    
}
