//
//  Pokemon+CoreDataProperties.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-25.
//  Copyright © 2020 Louise Chan. All rights reserved.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var type: String?
    @NSManaged public var expPoints: Int16
    @NSManaged public var battles: NSSet?

}

// MARK: Generated accessors for battles
extension Pokemon {

    @objc(addBattlesObject:)
    @NSManaged public func addToBattles(_ value: Battle)

    @objc(removeBattlesObject:)
    @NSManaged public func removeFromBattles(_ value: Battle)

    @objc(addBattles:)
    @NSManaged public func addToBattles(_ values: NSSet)

    @objc(removeBattles:)
    @NSManaged public func removeFromBattles(_ values: NSSet)

}
