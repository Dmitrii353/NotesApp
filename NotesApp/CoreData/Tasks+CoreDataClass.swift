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

extension Tasks : Identifiable {

}
