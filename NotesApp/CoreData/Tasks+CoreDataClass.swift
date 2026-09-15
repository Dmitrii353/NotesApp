//
//  Tasks+CoreDataClass.swift
//  m3#8
//
//  Created by Дима Люфт on 27.10.2024.
//
//

import Foundation
import CoreData

@objc(Tasks)
public class Tasks: NSManagedObject {

}
extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var countTask: Float
    @NSManaged public var notes: NSSet?

}

// MARK: Generated accessors for notes
extension Tasks {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension Tasks {
    var progress: Float {
        guard let notesCount = self.notes?.allObjects as? [Note], !notesCount.isEmpty else { return 0 }
        let completedCount = notesCount.filter {$0.execution}.count
        return Float(completedCount) / Float(notesCount.count)
    }
    
    var progressText: String {
        guard let notesCount = self.notes?.allObjects as? [Note], !notesCount.isEmpty else { return "0 заметок · 0%" }
        let completedCount = notesCount.filter {$0.execution}.count
        let percent = (Int(Float(completedCount) / Float(notesCount.count) * 100))
        return "\(notesCount.count) заметок · \(percent)%"
    }
}
