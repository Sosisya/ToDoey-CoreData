//
//  SceneDelegate.swift
//  ToDoey
//
//  Created by Луиза Самойленко on 17.03.2023.
//

import UIKit
import CoreData


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = configureCategoryController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func configureToDoListController() -> UIViewController {
        let toDoVC = UINavigationController(rootViewController: ToDoListTableViewController())
        return toDoVC
    }

    func configureCategoryController() -> UIViewController {
        let categoryVC = UINavigationController(rootViewController: CategoryTableViewController())
        return categoryVC
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

