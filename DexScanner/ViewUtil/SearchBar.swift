//
//  SearchBar.swift
//  DexScanner
//
//  Created by Janson Hendryli on 12/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//
//  Source: https://ordinarycoding.com/articles/search-view-in-swiftui/

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $text)
                    .foregroundColor(.primary)

                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
        }
        .padding(.horizontal)
    }
}
