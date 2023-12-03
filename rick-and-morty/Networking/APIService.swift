//
//  APIService.swift
//  training
//
//  Created by Anvar Kayumov on 03/12/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case dataIsEmpty
    case networkError(Error)
    case decodingError(Error)
    case invalidStatusCode
}

protocol APIServiceProtocol {
    var baseURL: String { get }
    func fetchCharacters(for page: Int, completion: @escaping (Result<RCharacters, NetworkError>) -> Void)
    func fetchCharacter(_ id: Int, _ completion: @escaping (Result<RCharacter, NetworkError>) -> Void)
}

final class APIService: APIServiceProtocol {

    var baseURL: String { "https://rickandmortyapi.com/api" }

    func fetchCharacters(for page: Int, completion: @escaping (Result<RCharacters, NetworkError>) -> Void) {
        request(with: .getCharacters(page: page), completion)
    }

    func fetchCharacter(_ id: Int, _ completion: @escaping (Result<RCharacter, NetworkError>) -> Void) {
        request(with: .getCharacter(id: id), completion)
    }

    private func request<T: Decodable>(with route: ClientRoute, _ completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL + route.path) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        print(url)

        URLSession.shared.dataTask(with: request) { (data, response, networkError) in
            if let networkError = networkError {
                completion(.failure(.networkError(networkError)))
                return
            }

            guard let data = data else {
                completion(.failure(.dataIsEmpty))
                return
            }

            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(.decodingError(error)))
            }

        }.resume()
    }
}
