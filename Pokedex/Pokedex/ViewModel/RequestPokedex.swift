//  Created by Kell Lanes on 06/07/21.

import Foundation
import Alamofire //Importação do Alamofire

struct PokemonAPIURL {
    static let Main: String = "http://pokeapi.co/api/v2/pokemon/"
}

typealias PokedexCompletion = (_ response: PokedexResponse) -> Void
typealias PokemonCompletion = (_ response: PokemonResponse) -> Void
typealias PokedexImageCompletion = (_ response: ImageResponse) -> Void

class ResquestPokedex
{
    let alamofireManager: SessionManager = {
        //Criação das configurações
        let configuration = URLSessionConfiguration.default
        //Tempo de timout em milisegundos
        configuration.timeoutIntervalForRequest = 10000
        configuration.timeoutIntervalForResource = 10000
        return SessionManager(configuration: configuration)
    }()
    let parse: ParsePokedex = ParsePokedex()
    
    
    
    func getAllPokemons(url:String?, completion:@escaping PokedexCompletion)
    {
        let page = url == "" || url == nil ? PokemonAPIURL.Main : url!
        alamofireManager.request(page, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
            { (response) in
                //Pega o status
                let statusCode = response.response?.statusCode
                switch response.result
                {
                //Status de erro ou sucesso
                case .success(let value):
                    //JSON com retorno
                    let resultValue = value as? [String: Any]
                    if statusCode == 404
                    {
                        if let description = resultValue?["detail"] as? String
                        {
                            let error = ServerError(msgError: description, statusCode: statusCode!)
                            completion(.serverError(description: error))
                        }
                    }
                    else if statusCode == 200
                    {
                        let model = self.parse.parseAllPokedex(response: resultValue)
                        completion(.success(model: model))
                    }
                case .failure(let error):
                    //Status de erro
                    let errorCode = error._code
                    if errorCode == -1009
                    {
                        let erro = ServerError(msgError: error.localizedDescription, statusCode: errorCode)
                        completion(.noConnection(description: erro))
                    }
                    else if errorCode == -1001
                    {
                        let erro = ServerError(msgError: error.localizedDescription, statusCode: errorCode)
                        completion(.timeOut(description: erro))
                    }
                }
        }
    }
    
    
    func getPokemon(id:Int, completion:@escaping (_ response: PokemonResponse) -> Void)
    {
        
        alamofireManager.request("\(PokemonAPIURL.Main)\(id)/", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON
            { (response) in
                
                let statusCode = response.response?.statusCode
                switch response.result
                {
                case .success(let value):
                    let resultValue = value as? [String: Any]
                    if statusCode == 404
                    {
                        if let description = resultValue?["detail"] as? String
                        {
                            let error = ServerError(msgError: description, statusCode: statusCode!)
                            completion(.serverError(description: error))
                        }
                    }
                    else if statusCode == 200
                    {
                        //Mando para o parse dos pokemons
                        let model = self.parse.parsePokemon(response: resultValue)
                        completion(.success(model: model))
                    }
                case .failure(let error):
                    let errorCode = error._code
                    if errorCode == -1009
                    {
                        let erro = ServerError(msgError: error.localizedDescription, statusCode: errorCode)
                        completion(.noConnection(description: erro))
                    }
                    else if errorCode == -1001
                    {
                        let erro = ServerError(msgError: error.localizedDescription, statusCode: errorCode)
                        completion(.timeOut(description: erro))
                    }
                }
        }
    }
    
    
    func getImagePokemon(url:String, completion:@escaping (_ response: ImageResponse) -> Void)
    {
        //O Evento responseData vai devoler um objeto Data case tenha sucesso
        alamofireManager.request(url, method: .get).responseData
            { (response) in
                if response.response?.statusCode == 200
                {
                    //Se o obejto Data view nulo mesmo retornando 200 algum erro aconteceu
                    guard let data = response.data else
                    {
                        let erro = ServerError(msgError: "Falha no Download, data vazio", statusCode: 404)
                        completion(.serverError(description: erro))
                        return
                    }
                    //Retorno a imagem
                    completion(.success(model: data))
                }
                else
                {
                    let erro = ServerError(msgError: "Falha no Download, data vazio", statusCode: 404)
                    completion(.serverError(description: erro))
                }
        }
    }


    
}

