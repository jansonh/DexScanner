//
//  PokemonView.swift
//  DexScanner
//
//  Created by Janson Hendryli on 09/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import SwiftUI

struct PokemonView: View {
    
    let pokemon: PokemonModel?
    
    var body: some View {
        VStack {
            HStack {
                Text(pokemon!.dexNo).font(.headline)
                Text(pokemon!.name).font(.title)
            }
            Image(pokemon!.spriteImagePath).padding()
            HStack {
                ForEach(pokemon!.pokemonTypes, id: \.self) { pokemonType in
                    Text(pokemonType.name.uppercased())
                        .padding(.all, 10)
                        .background(Color(UIColor(hex: Int(pokemonType.badge_color, radix: 16)!)))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
            }
            Text(pokemon!.dexEntry)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            Spacer()
        }.padding(.top, 10)
    }
}
