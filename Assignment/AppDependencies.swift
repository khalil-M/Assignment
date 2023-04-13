//
//  AppDependencies.swift
//  Assignment
//
//  Created by Khalil Mhelheli on 13/4/2023.
//

import Foundation
import UIKit

class AppDependencies {
    
    static let shared = AppDependencies()
    
    var window: UIWindow?
    
    private init(){
        
    }

    public func start() {
        let isLoggedIn:Bool = true
        if isLoggedIn {
            setRootViewController(makeAssignmentsViewController())
        } else {
//            setRootViewController()
        }
    }
    
    public func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
    }
    
    public func setScene(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        window?.makeKeyAndVisible()
    }
    
    func makeAssignmentsViewController() -> UIViewController {
       
        let viewController = AssignmentsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.title = "All events"
        navigationController.tabBarItem.image = UIImage(named: "AllEvents")
        navigationController.tabBarController?.tabBar.tintColor = .red
        return navigationController
    }
}
