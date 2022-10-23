//
//  Movie.swift
//  Netflix Clone
//
//  Created by Suguru on 10/20/22.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Identifiable, Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int?
    let releaseDate: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, overview
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage  = "vote_average"
    }
}

/*
 adult = 0;
 "backdrop_path" = "/tSxbUnrnWlR5dQvUgqMI7sACmFD.jpg";
 "genre_ids" =             (
     14,
     28,
     18
 );
 id = 779782;
 "media_type" = movie;
 "original_language" = en;
 "original_title" = "The School for Good and Evil";
 overview = "Best friends Sophie and Agatha navigate an enchanted school for young heroes and villains \U2014 and find themselves on opposing sides of the battle between good and evil.";
 popularity = "92.39";
 "poster_path" = "/6oZeEu1GDILdwezmZ5e2xWISf1C.jpg";
 "release_date" = "2022-10-19";
 title = "The School for Good and Evil";
 video = 0;
 "vote_average" = "7.245";
 "vote_count" = 51;
 */
