//
//  StorageManager.swift
//  Notes
//
//  Created by Егор  Хлямов on 14.05.2023.
//

import Foundation
import UIKit
import CoreData

public final class CoreDataManager: NSObject{
    public static let shared = CoreDataManager()
    
    private override init(){}
    
    private var appDelegate: AppDelegate{
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context:NSManagedObjectContext{
        appDelegate.persistentContainer.viewContext
    }
    public func createFolder(name:String){
        var id: Int16 = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        guard let fetchRequest = try? context.fetch(fetchRequest) as? [Folder] else {return}
        if fetchRequest.count == 0{
            id = 0
            }
        else{
            id = fetchRequest[fetchRequest.count - 1].id + 1
            }
        
        
        guard let folderEntityDescription = NSEntityDescription.entity(forEntityName: "Folder", in: context) else{return}
        //guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "Note", in: context) else{return}
        let folder = Folder(entity: folderEntityDescription, insertInto: context)
        //let note = Note(entity: noteEntityDescription, insertInto: context)
        folder.id = Int16(id)
        folder.name = name
        //note.text = ""
        //note.lastEditing = NSDate() as Date
        appDelegate.saveContext()
        }
    public func fetchFolders() ->[Folder]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            guard let fetchRequest = try? context.fetch(fetchRequest) as? [Folder] else {return []}
            return fetchRequest
            
        }
    }
    public func updateFolder(id: Int16, name:String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            guard let folders = try? context.fetch(fetchRequest) as? [Folder],
                  let folder =  folders.first(where: {$0.id == id})  else{return}
            folder.name = name
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllFolders(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            let folders = try? context.fetch(fetchRequest) as? [Folder]
            folders?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    }
    public func deleteAllNotes(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            let notes = try? context.fetch(fetchRequest) as? [Note]
            notes?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    public func deleteFolder(id:Int16){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            guard let folders = try? context.fetch(fetchRequest) as? [Folder],
                  let folder = folders.first(where: {$0.id == id}) else{return}
            context.delete(folder)
        }
        appDelegate.saveContext()
    }
    public func deleteNote(id:Int16){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note],
                  let note = notes.first(where: {$0.id == id}) else{return}
            context.delete(note)
        }
        appDelegate.saveContext()
    }
    
    public func deleteNotesByFolder(id:Int16){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note] else{return}
            let filteredNotes = notes.filter({$0.folderId == id})
            for note in filteredNotes{
                context.delete(note)
            }
        }
        appDelegate.saveContext()
    }
    
    public func createNote(folderId: Int16) -> Int16{
        var id: Int16 = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        guard let fetchRequest = try? context.fetch(fetchRequest) as? [Note] else {return 0}
        if fetchRequest.count == 0{
            id = 0
            }
        else{
            id = fetchRequest[fetchRequest.count - 1].id + 1
            }
        
        
        guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "Note", in: context) else{return 0}
        //guard let noteEntityDescription = NSEntityDescription.entity(forEntityName: "Note", in: context) else{return}
        let note = Note(entity: noteEntityDescription, insertInto: context)
        //let note = Note(entity: noteEntityDescription, insertInto: context)
        note.id = Int16(id)
        note.text = ""
        note.folderId = folderId
        note.lastEditing = NSDate() as Date
        //note.text = ""
        //note.lastEditing = NSDate() as Date
        appDelegate.saveContext()
        return id
        }
    public func fetchNotes(folderId: Int16) ->[Note]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note] else{return []}
            let result =  notes.filter({$0.folderId == folderId})
            return result
        }
       
    }
    public func fetchNote(id: Int16) -> Note?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note] else{return nil}
            let result =  notes.first(where: {$0.id == id})
            return result
        }
       
    }
    public func updateNote(id: Int16, text:String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note],
                  let note = notes.first(where: {$0.id == id}) else{return}
            note.text = text
        }
        appDelegate.saveContext()
    }
}
