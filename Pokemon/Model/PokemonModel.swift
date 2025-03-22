//
//  PokemonModel.swift
//  Pokemon
//
//

import Foundation

struct PokemonModel: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let englishName: String?
}
