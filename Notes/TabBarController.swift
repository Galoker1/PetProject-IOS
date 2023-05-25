//
//  TabBarController.swift
//  Notes
//
//  Created by Егор  Хлямов on 13.05.2023.
//

import UIKit

enum Tabs{
    case notes
    case settings
}
final class TabBarController: UITabBarController{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        tabBar.tintColor = Resources.Colors.accent
        let notesController = FoldersController()
        let settingsController = SettingsViewController()
        settingsController.delegate = notesController
        let notesNavigation = UINavigationController(rootViewController: notesController)
        let settingsNavigation = UINavigationController(rootViewController: settingsController)
        
        notesNavigation.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.notes, image: Resources.Images.TabBar.notes, tag: Tabs.notes.hashValue)
        settingsNavigation.tabBarItem = UITabBarItem(title: Resources.Strings.TabBar.settings, image: Resources.Images.TabBar.settings, tag: Tabs.settings.hashValue)
        
        setViewControllers([notesNavigation,
                           settingsNavigation
                           ],
                           animated: false)
    }
    
    func setColors(){
        if SettingsSingletone.shared.getTheme() == 0{
           
            view.overrideUserInterfaceStyle = .dark
        }
        else{
            view.overrideUserInterfaceStyle = .light
        }
    }

    
}
