//
//  Extensions.swift
//  InstaDev
//
//  Created by apple on 18.06.2022.
//

import UIKit

//MARK: - UIImage extension
extension UIImage {
    func cropImage() -> UIImage {
        let crop = CGRect(x: 1,
                          y: 1,
                          width: self.size.width - 2,
                          height: self.size.height - 2)
        
        let cgImage = self.cgImage!.cropping(to: crop)
        let image: UIImage = UIImage(cgImage: cgImage!)
        return image
    }
}

//MARK: - Srting extension
extension String {
    func stringToArray() -> [Int] {
        let stringToArr = self.components(separatedBy: ",")
        return stringToArr.map { Int($0) ?? 0 }
    }
}
