//
//  PokedexManager.swift
//  DexScanner
//
//  Created by Janson Hendryli on 10/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation

class PokedexManager: ObservableObject {
    @Published var pokemon = [PokemonModel]()

    private let db = DatabaseLoader()
    
    func load() {
        var pokemonModels: [PokemonModel] = []
        
        let pokemonLists = db.loadPokemon()
        for pokemonSpecies in pokemonLists {
            // Convert from Realm List to Swift Array, so that we can pass it to the pokemonModels
            let pokemonTypes: [PokemonType] = Array(pokemonSpecies.types)

            let model = PokemonModel(pokemonSpecies.dexNo, pokemonSpecies.name, pokemonTypes, pokemonSpecies.dexEntry)
            pokemonModels.append(model)
        }
        
        DispatchQueue.main.async {
            self.pokemon = pokemonModels
        }
    }
}
