//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by a.n.lazarev on 16.01.2024.
//

import Foundation

struct AlertModel {
    
    let title: String
    
    let message: String
    
    let buttonText: String
    
    let completion: () -> Void
}
