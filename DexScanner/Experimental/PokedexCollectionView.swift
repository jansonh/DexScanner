//
//  PokedexCollectionView.swift
//  DexScanner
//
//  Created by Janson Hendryli on 12/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import SwiftUI

struct PokedexCollectionView: View {
    @ObservedObject var pokedexManager = PokedexManager()

    var body: some View {
        QGrid(pokedexManager.pokemon, columns: 5) {
            GridCell(pokemon: $0)
        }
        .navigationBarTitle("Pokédex", displayMode: .automatic)
        .onAppear {
            self.pokedexManager.load()
        }
    }
}

struct GridCell: View {
    var pokemon: PokemonModel
    
    var body: some View {
        VStack {
            Image(pokemon.spriteImagePath)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .shadow(color: .primary, radius: 5)
                .padding([.horizontal, .top], 7)
            Text(pokemon.dexNo).lineLimit(1)
        }
    }
}

/*
struct PokedexCollectionView: View {
    @ObservedObject var pokedexManager = PokedexManager()
    
    private var numberOfRows: Int {
        let rows = pokedexManager.pokemon.count / K.numberOfPokemonPerRow
        
        var additionalRow = 1
        if pokedexManager.pokemon.count % K.numberOfPokemonPerRow == 0 {
            additionalRow = 0
        }
                
        return rows + additionalRow
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0 ..< numberOfRows, id: \.self) { row in
                    CollectionViewRow(pokemonSlices: self.pokedexManager.pokemon[row * K.numberOfPokemonPerRow ..< min(self.pokedexManager.pokemon.count, row * K.numberOfPokemonPerRow + K.numberOfPokemonPerRow)])
                }
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Pokédex", displayMode: .automatic)
        .onAppear {
            self.pokedexManager.load()
        }
    }
}

struct CollectionViewRow: View {
    let pokemonSlices: ArraySlice<PokemonModel>
    
    var body: some View {
        HStack {
            ForEach(pokemonSlices, id: \.self) { pokemon in
                NavigationLink(destination: PokemonView(pokemon: pokemon)) {
                    Spacer()
                    VStack {
                        Image(pokemon.spriteImagePath)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text(pokemon.dexNo).font(.caption)
                    }
                    Spacer()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct PokedexCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexCollectionView()
    }
}
*/
