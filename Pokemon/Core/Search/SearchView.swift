//
//  SearchView.swift
//  Pokemon
//
//

@Observable
@MainActor
class SearchViewModel {
    
    var pokemon: PokemonModel?
    var searchTerm = ""
    var allPokemons: [PokemonModel] = []
    
    var filteredPokemons: [PokemonModel] {
        if searchTerm.isEmpty {
            return []
        } else {
            return allPokemons.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        }
    }
}

import SwiftUI

struct SearchView: View {
    
    @State var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let pokemon = viewModel.pokemon {
                    AsyncImage(url: URL(string: pokemon.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle().foregroundStyle(.secondary)
                    }
                    .frame(width: 120, height: 120)
                    
                    Text(pokemon.name)
                        .font(.title3)
                        .fontWeight(.medium)
                } else if !viewModel.searchTerm.isEmpty && viewModel.filteredPokemons.isEmpty {
                    ContentUnavailableView(
                        "Pas de pokémon trouvé",
                        systemImage: "magnifyingglass",
                        description: Text(
                            "Veuillez entrer un autre nom de Pokémon"
                        )
                    )
                } else if viewModel.searchTerm.isEmpty {
                    ContentUnavailableView(
                        "Rechercher un Pokémon",
                        systemImage: "magnifyingglass",
                        description: Text(
                            "Entrez le nom d'un Pokémon"
                        )
                    )
                } else {
                    List(viewModel.filteredPokemons) { pokemon in
                        Button(action: {
                            self.viewModel.pokemon = pokemon
                            viewModel.searchTerm = pokemon.name
                        }) {
                            HStack {
                                AsyncImage(url: URL(string: pokemon.image)) { image in
                                    image
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .foregroundStyle(.secondary)
                                        .frame(width: 80, height: 80)
                                }
                                
                                Text(pokemon.name)
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Rechercher")
            .task(id: viewModel.searchTerm) {
                do {
                    viewModel.allPokemons = try await NetworkHelper.shared.fetchData()
                } catch {
                    print("Error loading pokemons: \(error)")
                }
            }
            .searchable(text: $viewModel.searchTerm, prompt: "Rechercher un Pokémon...")
        }
    }
}

#Preview {
    SearchView(
        viewModel: SearchViewModel()
    )
}
