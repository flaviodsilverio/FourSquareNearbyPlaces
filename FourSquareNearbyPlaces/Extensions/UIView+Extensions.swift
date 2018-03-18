//
//  UIView+Extensions.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func startLoading() {

        if self.viewWithTag(-999) != nil {
            return
        }

        let loader = UIActivityIndicatorView(frame: self.bounds)
        loader.tag = -999
        self.addSubview(loader)
        loader.startAnimating()

    }

    func stopLoading() {

        guard let loader = self.viewWithTag(-999) as? UIActivityIndicatorView else { return }

        loader.stopAnimating()
        loader.removeFromSuperview()
    }

}
