//
//  Resourсes.swift
//  Notes
//
//  Created by Егор  Хлямов on 13.05.2023.
//

import UIKit

enum Resources{
    enum Colors {
        static var accent = UIColor(hexString: "#ff8400")
        static var inactive = UIColor(hexString: "#615f5d")
    }
    enum Strings{
        enum TabBar{
            static var notes = "Notes"
            static var settings = "Settings"
        }
    }
    enum Images{
        enum TabBar{
            static var notes = UIImage(systemName: "note")
            static var settings = UIImage(systemName: "gear.circle.fill")
        }
    }
}
