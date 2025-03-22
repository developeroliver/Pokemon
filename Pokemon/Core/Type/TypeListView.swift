//
//  TypeListView.swift
//  Pokemon
//
//

import SwiftUI

@Observable
@MainActor
class TypeListViewModel {
    
    var typePokemons: [PokemonModel] = []
}

struct TypeListView: View {
    
    @State var viewModel: TypeListViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.typePokemons) { type in
                HStack(spacing: 8) {
                    AsyncImage(
                        url: URL(string: type.image)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                        }
                        .frame(width: 40, height: 40)
                    
                    Text(type.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("Types")
            .task {
                do {
                    viewModel.typePokemons = try await NetworkHelper.shared.fetchType()
                } catch {
                    
                }
            }
        }
    }
}

#Preview {
    TypeListView(
        viewModel: TypeListViewModel()
    )
}
