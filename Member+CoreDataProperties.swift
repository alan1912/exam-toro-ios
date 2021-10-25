//
//  Member+CoreDataProperties.swift
//  ExamToroApp
//
//  Created by alan liang on 2021/10/22.
//
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int32
    @NSManaged public var gender: Int16
    @NSManaged public var id: Int32

}

extension Member : Identifiable {

}
