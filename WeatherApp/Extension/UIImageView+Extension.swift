//
//  UIImageView+Extension.swift
//  WeatherApp
//
//  Created by KuRaMa on 1/15/21.
//

import UIKit

extension UIImageView {
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func storeImage(urlString: String, image: UIImage) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = image.pngData()
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String]
        if dict == nil {
            dict = [String: String]()
        }
        
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "ImageCache")
    }

    func downloadImage(urlString: String) {
        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String] {
            if let path = dict[urlString] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    self.image = UIImage(data: data)
                }
            }
        }
        
        guard let url = URL(string: urlString) else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if let image = UIImage(data: data) {
                    self.storeImage(urlString: urlString, image: image)
                    self.image = image
                }
            }
        }
    }
    
}
