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
        VStack {
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
        }
        .navigationBarTitle("Pokédex", displayMode: .automatic)
        .onAppear {
            self.pokedexManager.load()
        }
    }
}

/*
struct PokedexView: View {
     
     @ObservedObject var pokedexManager = PokedexManager()
     @State private var searchText = ""
     
     var body: some View {
         VStack {
             SearchBar(text: $searchText)
             List {
                 ForEach(pokedexManager.pokemon.filter{$0.name.hasPrefix(searchText) || searchText == ""}, id:\.self) { pokemon in
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
             }
             .gesture(DragGesture().onChanged { _ in
                 UIApplication.shared.endEditing(true)
             })
         }
         .navigationBarTitle("Pokédex", displayMode: .automatic)
         .onAppear {
             self.pokedexManager.load()
         }
     }
 }

 extension UIApplication {
     func endEditing(_ force: Bool) {
         self.windows
             .filter{$0.isKeyWindow}
             .first?
             .endEditing(force)
     }
 }
 */
