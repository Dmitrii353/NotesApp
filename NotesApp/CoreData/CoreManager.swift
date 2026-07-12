//
//  CoreManager.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import Foundation
import CoreData

class CoreManager {
    var tasks: [Tasks] = []
    static let shared = CoreManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   
    
    // createTask
    func createTask( name: String, description: String) {
        let task = Tasks(context: persistentContainer.viewContext)
        task.date = Date()
        task.id = UUID().uuidString
        task.name = name
        saveContext()
        getFolder()
    }
    
    // getTask
    func getFolder() {
        let task = Tasks.fetchRequest()
        let result = try? persistentContainer.viewContext.fetch(task)
        self.tasks = result ?? []
        
    }
    
    // createNote
    func createNote(task: Tasks?, name: String,image: String, details: String) {
        guard let task else { return }
        let note = Note(context: persistentContainer.viewContext)
        note.name = name
        note.photo = image
        note.details = details
        note.id = UUID().uuidString
        note.tasks = task
        
        saveContext()
        getFolder()
    }
    
    func deleteNote(note: Note) {
        persistentContainer.viewContext.delete(note)
        saveContext()
    }
    
    func deleteTask(task: Tasks) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    func toggleCheckBox(note: Note) {
        saveContext()
        getFolder()
    }
    
    
    
    func path() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
        return url
    }
    
    func saveFile(file: Data, imageName: String) {
        let path = path()
        let photoURL = path.appending(path: "photo/avatar")
        try? FileManager.default.createDirectory(at: photoURL, withIntermediateDirectories: true)
        let imageUrl = photoURL.appending(path: imageName)
        try? file.write(to: imageUrl)
        print(imageUrl)
    }
    
    func readFile(imageName: String) -> Data? {
        let path = path().appending(path: "photo/avatar/\(imageName)")
        let data = try? Data(contentsOf: path)
        print(path)
        return data
    }
}


