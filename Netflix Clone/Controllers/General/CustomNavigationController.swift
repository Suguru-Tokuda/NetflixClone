//
//  CustomNavigationController.swift
//  Netflix Clone
//
//  Created by Suguru on 10/23/22.
//

import UIKit

class CustomNavigationController: UINavigationController {
    var isNewViewControllerBeingAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func contains(viewController: UIViewController) -> Bool {
        return self.viewControllers.map{ $0.className }.contains(viewController.className)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (!self.isNewViewControllerBeingAdded && !self.contains(viewController: viewController)) {
            self.isNewViewControllerBeingAdded = true
            super.pushViewController(viewController, animated: true)
        }
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.isNewViewControllerBeingAdded = false
    }
}
