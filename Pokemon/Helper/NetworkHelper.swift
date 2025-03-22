//
//  NetworkHelper.swift
//  Pokemon
//
//

import Foundation

struct NetworkHelper {

    static let shared = NetworkHelper()

    private init() {}

    func fetchData<T: Decodable>() async throws -> [T] {
        let urlString = "https://pokebuildapi.fr/api/v1/pokemon"
        guard let url = URL(string: urlString) else {
            throw NetworkHelperError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkHelperError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: data)
        } catch {
            throw NetworkHelperError.invalidData
        }
    }
    
    func fetchPokemon<T: Decodable>(pokemonName: String) async throws -> T {
        let urlString = "https://pokebuildapi.fr/api/v1/pokemon/\(pokemonName)"
        guard let url = URL(string: urlString) else {
            throw NetworkHelperError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkHelperError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkHelperError.invalidData
        }
    }
    
    func fetchType<T: Decodable>() async throws -> T {
        let urlString = "https://pokebuildapi.fr/api/v1/types"
        guard let url = URL(string: urlString) else {
            throw NetworkHelperError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkHelperError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkHelperError.invalidData
        }
    }
}

enum NetworkHelperError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
