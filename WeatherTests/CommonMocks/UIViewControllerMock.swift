//
//  UIViewControllerMock.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

class UIViewControllerMock: UIViewController {
    var presented: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presented = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    var dismissedCalled: Bool?
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissedCalled = true
        super.dismiss(animated: flag, completion: completion)
    }
}
