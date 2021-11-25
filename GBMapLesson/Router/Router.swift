//
//  BaseRouter.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 18.11.2021.
//

import UIKit

protocol ViewControllerRouterInput {
    func navigateToViewController(value: Int)
}

final class ViewControllerRouter: ViewControllerRouterInput {

    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - ViewControllerRouterInput

    func navigateToViewController(value: Int) {
        let pushedViewController = ViewController()
        pushedViewController.configure(viewModel: MapViewModel(value: value))
        viewController?.navigationController?.pushViewController(pushedViewController, animated: true)
    }

}
