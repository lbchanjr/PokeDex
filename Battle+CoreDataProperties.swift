//
//  Battle+CoreDataProperties.swift
//  PokeDex
//
//  Created by Louise Chan on 2020-05-25.
//  Copyright © 2020 Louise Chan. All rights reserved.
//
//

import Foundation
import CoreData


extension Battle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Battle> {
        return NSFetchRequest<Battle>(entityName: "Battle")
    }

    @NSManaged public var battleDateTime: NSDate?
    @NSManaged public var winningPokemon: Pokemon?

}
