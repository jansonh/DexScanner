//
//  Pokemon.swift
//  PreloadedRealmGenerator
//
//  Created by Janson Hendryli on 08/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation
import RealmSwift

class Pokemon: Object {
    @objc dynamic var dexNo: String = "000"
    @objc dynamic var name: String = "MissingNo"
    @objc dynamic var dexEntry: String = "This is a glitch Pokémon."
    
    let types = List<PokemonType>()
    
    override class func primaryKey() -> String? {
        return "dexNo"
    }
}
