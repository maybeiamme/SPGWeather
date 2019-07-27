//
//  UINavigationControllerMock.swift
//  WeatherTests
//
//  Created by Shepherd on 27/7/19.
//  Copyright © 2019 Jin. All rights reserved.
//

import UIKit

class NavigationViewControllerMock: UINavigationController {
    var pushedViewControllers = Array<UIViewController>()
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: true)
    }
    var popViewControllerCalled: Bool?
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return super.popViewController(animated: true)
    }
}
