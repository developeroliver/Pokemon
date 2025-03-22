//
//  TabBarView.swift
//  Pokemon
//
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            PokemonView(viewModel: PokemonViewModel())
                .tabItem {
                    Label("Pokémon", systemImage: "list.dash")
                }
            
            SearchView(viewModel: SearchViewModel())
                .tabItem {
                    Label("Rechercher", systemImage: "magnifyingglass")
                }
            
            TypeListView(viewModel: TypeListViewModel())
                .tabItem {
                    Label("Types", systemImage: "square.and.arrow.up")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    TabBarView()
}
