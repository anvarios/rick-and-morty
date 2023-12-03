//
//  ClientRoute.swift
//  training
//
//  Created by Anvar Kayumov on 03/12/23.
//

public enum ClientRoute {
    case getCharacters(page: Int)
    case getCharacter(id: Int)

    public var path: String {
        switch self {
        case .getCharacters(let page): return "/character/?page=\(page)"
        case .getCharacter(let id): return "/character/\(id)"
        }
    }

    public var method: String {
        return "GET"
    }

}
