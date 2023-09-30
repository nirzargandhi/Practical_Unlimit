//
//  UIImageView+Extension.swift
//

import UIKit

//MARK: - UIImageView Extension
extension UIImageView {

    func downloadImage(from url: URL, contentMode: UIView.ContentMode = .scaleAspectFit, placeholder: UIImage? = nil, completionHandler: ((UIImage?) -> Void)? = nil) {

        image = placeholder
        self.contentMode = contentMode

        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { (data, response, _) in

            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
            else {
                completionHandler?(nil)
                return
            }

            DispatchQueue.main.async {
                self.image = image
                completionHandler?(image)
            }

        }.resume()
    }
}
