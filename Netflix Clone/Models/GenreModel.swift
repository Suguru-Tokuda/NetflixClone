//
//  GenreModel.swift
//  Netflix Clone
//
//  Created by Suguru on 10/22/22.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [GenreModel]
}

struct GenreModel: Identifiable, Codable {
    let id: Int
    let name: String
}
