//
//  PokemonModel.swift
//  DexScanner
//
//  Created by Janson Hendryli on 10/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation

struct PokemonModel: Decodable, Identifiable {
    var id: String {
        return dexNo
    }
    
    let dexNo: String
    let name: String
    let pokemonTypes: [PokemonType]
    let dexEntry: String
    
    var spriteImagePath: String {
        return "Sprites/\(dexNo)\(name)"
    }
    
    var titleString: String {
        return "#\(dexNo) - \(name)"
    }
    
    init(_ dexNo: String, _ name: String, _ pokemonTypes: [PokemonType], _ dexEntry: String) {
        self.dexNo = dexNo
        self.name = name
        self.pokemonTypes = pokemonTypes
        self.dexEntry = dexEntry
    }
}
