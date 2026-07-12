//
//  Note+CoreDataClass.swift
//  m3#8
//
//  Created by Дима Люфт on 29.10.2024.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {

}
extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var details: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var execution: Bool
    @NSManaged public var tasks: Tasks?

}

extension Note : Identifiable {

}
