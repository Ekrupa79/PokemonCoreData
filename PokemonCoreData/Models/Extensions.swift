//
//  Extensions.swift
//  Pokedex
//
//  Created by Mac on 11/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

extension UIImageView{
    func imageFrom(url:String){
        let cache = GlobalCache.shared.imageCache
        if let image = cache.object(forKey: url as NSString){
            self.image = image
            return
        }
        JSONCalls.getImage(from: url){
            (image,error) in
            guard error == nil else {return}
            guard let image = image else {return}
            cache.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

extension UIViewController{
    class func displaySpinner(onView: UIView) -> UIView{
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    class func removeSpinner(spinner: UIView){
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension String{
    func capitalizeFirstLetter() -> String{
        return prefix(1).uppercased()+dropFirst()
    }
    mutating func capitalizeFirstLetter(){
        self = self.capitalizeFirstLetter()
    }
}
