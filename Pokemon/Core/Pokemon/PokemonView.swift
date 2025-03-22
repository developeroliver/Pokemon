//
//  PokemonView.swift
//  Pokemon
//
//

import SwiftUI

@Observable
@MainActor
class PokemonViewModel {
    
   var pokemons: [PokemonModel] = []
}

struct PokemonView: View {

    @Namespace private var topID
    @State var viewModel: PokemonViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                ScrollViewReader { proxy in
                    List(viewModel.pokemons, id: \.id) { pokemon in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(pokemon.name)
                                    .bold()
                                    .font(.title3)
                                
                                Text("\(pokemon.id)")
                                    .padding()
                            }
                            Spacer()
                            AsyncImage(
                                url: URL(string: pokemon.image)
                            ) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 120, height: 120)
                        }
                        .id(pokemon.id)
                    }
                    .task {
                        do {
                            viewModel.pokemons = try await NetworkHelper.shared.fetchData()
                        } catch NetworkHelperError.invalidData {
                            print("Invalid Data")
                        } catch NetworkHelperError.invalidURL {
                            print("Invalid URL")
                        } catch NetworkHelperError.invalidResponse {
                            print("Invalid Response")
                        } catch {
                            print("unexpected error: \(error)")
                        }
                    }
                    .onAppear {
                        if let firstPokemon = viewModel.pokemons.first {
                            withAnimation {
                                proxy.scrollTo(firstPokemon.id, anchor: .top)
                            }
                        }
                    }
                    .navigationTitle("Pokemon")
                }
            }
        }
    }
}

#Preview {
    PokemonView(
        viewModel: PokemonViewModel()
    )
}


