//  Created by Kell Lanes on 06/07/21.

import Foundation

typealias ParseReponseDict = [String: Any]?
typealias PokemonSpriteDict = [String: Any]

class ParsePokedex
{
    func parseAllPokedex(response: ParseReponseDict) -> PokedexModel
    {
        //Faço o unwrap do dicionario enviado pelo request, caso for nulo aciono a função de init para criar model vazio
        guard let response = response else { return PokedexModel() }
        //Coloco os valores do dicionario em variaveis
        //Caso alguma dessas chaves estiverem vazias o valor atribuido na variavel será oque está depois do ??
        let count = response["count"] as? Int ?? 0
        let next = response["next"] as? String ?? ""
        let previous = response["previous"] as? String ?? ""
        //Preciso apenas da quantidade de filhos do array
        let resultList = response["results"] as? [[String: Any]] ?? []
        let results = resultList.count
        return PokedexModel(count: count, next: next, previous: previous, results: results)
    }
    
    
    func parsePokemon(response: ParseReponseDict) -> PokemonModel
    {
        guard let response = response else { return PokemonModel() }
        let name = response["name"] as? String ?? ""
        let id = response["id"] as? Int ?? 0
        let sprites = response["sprites"] as? PokemonSpriteDict
        let urlImage = sprites?["front_default"] as? String ?? ""
        return PokemonModel(id: id, name: name, urlImage: urlImage)
    }
}
