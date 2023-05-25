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
    // Создание папки
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
    
    // Все папки
    public func fetchFolders() ->[Folder]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            guard let fetchRequest = try? context.fetch(fetchRequest) as? [Folder] else {return []}
            return fetchRequest
            
        }
    }
    
    // Изменение папки
    public func updateFolder(id: Int16, name:String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            guard let folders = try? context.fetch(fetchRequest) as? [Folder],
                  let folder =  folders.first(where: {$0.id == id})  else{return}
            folder.name = name
        }
        appDelegate.saveContext()
    }
    
    // Удаление всех папок
    public func deleteAllFolders(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            let folders = try? context.fetch(fetchRequest) as? [Folder]
            folders?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    }
    // Удаление всех заметок
    public func deleteAllNotes(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            let notes = try? context.fetch(fetchRequest) as? [Note]
            notes?.forEach{context.delete($0)}
        }
        appDelegate.saveContext()
    }
    
    // Удаление папки
    public func deleteFolder(id:Int16){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
        do{
            guard let folders = try? context.fetch(fetchRequest) as? [Folder],
                  let folder = folders.first(where: {$0.id == id}) else{return}
            context.delete(folder)
        }
        appDelegate.saveContext()
    }
    
    // Удаление заметки
    public func deleteNote(id:Int16){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note],
                  let note = notes.first(where: {$0.id == id}) else{return}
            context.delete(note)
        }
        appDelegate.saveContext()
    }
    
    // Удаление заметки по ID
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
    
    // Создание Заметки
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
    
    // Все заметки из папки
    public func fetchNotes(folderId: Int16) ->[Note]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note] else{return []}
            let result =  notes.filter({$0.folderId == folderId})
            return result
        }
       
    }
    
    // Получение заметки
    public func fetchNote(id: Int16) -> Note?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            guard let notes = try? context.fetch(fetchRequest) as? [Note] else{return nil}
            let result =  notes.first(where: {$0.id == id})
            return result
        }
       
    }
    
    // Изменение заметки
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
