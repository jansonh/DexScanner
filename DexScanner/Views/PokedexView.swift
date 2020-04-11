//
//  PokedexView.swift
//  DexScanner
//
//  Created by Janson Hendryli on 09/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import SwiftUI

struct PokedexView: View {
    
    @ObservedObject var pokedexManager = PokedexManager()
    
    var body: some View {
        List(pokedexManager.pokemon) { pokemon in
            NavigationLink(destination: PokemonView(pokemon: pokemon)) {
                HStack {
                    HStack {
                        Image(pokemon.spriteImagePath)
                            .resizable()
                            .frame(width: 70, height: 70)
                        Text(pokemon.dexNo).font(.caption)
                    }
                    Spacer()
                    Text(pokemon.name)
                }
            }
        }
        .navigationBarTitle("Pokédex", displayMode: .automatic)
        .onAppear {
            self.pokedexManager.load()
        }
    }
}
