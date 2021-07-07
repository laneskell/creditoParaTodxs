//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Kell Lanes on 06/07/21.

import Foundation

struct PokemonModel
{
    var id: Int
    var name: String
    var urlImage: String
}
extension PokemonModel
{
    init()
    {
        self.id = 0
        self.name = ""
        self.urlImage = ""
    }
}
