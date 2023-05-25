//
//  tepms.swift
//  Notes
//
//  Created by Егор  Хлямов on 16.05.2023.
//

import Foundation

public final class SettingsSingletone{
    
    public var fontSize:Int
    public var colorTheme:Int
    
    public static let shared = SettingsSingletone()
    private let defaults = UserDefaults.standard
    
    private init(){
        fontSize = defaults.integer(forKey: "FontSize")
        colorTheme = defaults.integer(forKey: "Theme")
    }
    
    func setTheme(theme:Int){
        defaults.set(theme, forKey: "Theme")
        colorTheme = defaults.integer(forKey: "Theme")
    }
    func getTheme() -> Int{
        defaults.integer(forKey: "Theme")
    }
    func getFontSize() -> Int{
        defaults.integer(forKey: "FontSize")
    }
    func setFontSize(size: Int){
        defaults.set(size, forKey: "FontSize")
        fontSize = defaults.integer(forKey: "FontSize")
    }
}
