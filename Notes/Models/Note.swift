//
//  Note.swift
//  Notes
//
//  Created by Егор  Хлямов on 14.05.2023.
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {}

extension Note{
    @NSManaged public var id: Int16
    @NSManaged public var folderId: Int16
    @NSManaged public var text: String
    @NSManaged public var lastEditing: Date
}

extension Note: Identifiable{}
