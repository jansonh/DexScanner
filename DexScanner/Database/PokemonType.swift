//
//  Types.swift
//  PreloadedRealmGenerator
//
//  Created by Janson Hendryli on 08/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation
import RealmSwift

class PokemonType: Object, Decodable {
    @objc dynamic var name: String = "unknown"
    @objc dynamic var complete_name: String = "unknown"
    @objc dynamic var badge_color: String = "000000"
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
