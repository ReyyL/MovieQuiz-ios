//
//  Movie.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 24.01.2024.
//

import UIKit

struct Actor {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct Movie {
    let id: String
    let title: String
    let year: Int
    let image: String
    let releaseDate: String
    let runtimeMins: Int
    let directors: String
    let actorList: [Actor]
}


