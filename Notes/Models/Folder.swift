//
//  Note.swift
//  Notes
//
//  Created by Егор  Хлямов on 14.05.2023.
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {}

extension Folder{
    @NSManaged public var id: Int16
    @NSManaged public var name: String
}
extension Folder: Identifiable{}
