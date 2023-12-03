//
//  RCharacters.swift
//  rick-and-morty
//
//  Created by Anvar Kayumov on 03/12/23.
//

import Foundation

struct RCharacters: Decodable {
    let results: [RCharacter]
    let pagination: RPagination

    enum CodingKeys: String, CodingKey {
        case results
        case pagination = "info"
    }
}

struct RPagination: Decodable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}

struct RCharacter: Decodable, Hashable {
    let id: Int
    let name: String
    let image: URL?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RCharacter, rhs: RCharacter) -> Bool {
        lhs.id == rhs.id
    }
}
