//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Kell Lanes on 06/07/21.
//

import Foundation
import UIKit

class PokedexViewController: UITableViewController {
    //Variável responsável pelos Requests
    var requestPokedex: ResquestPokedex = ResquestPokedex()
    //Guarda todos os pokemons
    var resultModel: PokedexModel?
    //Guarda a quantidade de resultados que serão exibidos
    var resultCount = 0
    //Guarda as informações de cada pokemon separadamente
    var pokemons = [PokemonModel]()
    //Guarda as imagens de cada pokemon separadamente
    var imagePokemons = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //requests todos pokemons
    fileprivate func loadPokedex(url: String?)
    {
        requestPokedex.getAllPokemons(url: url) { (response) in
            switch response
            {
            case .success(let model):
                //Passa o model geral para nossa variavel
                self.resultModel = model
                //Essa função será criada futuramente
                //Pedimos para carregar um pokemon especifico, estamos      passando self.resultCount+1 porque os ids dos pokemons na API    começam a partir do 1
                self.loadPokemon(self.resultCount+1)
                //Incrementamos a quantidade de resultados que serão exibidos
                self.resultCount += model.results
            case .serverError(let description):
                print(description)
            case .timeOut(let description):
                print(description)
            case .noConnection(let description):
                print(description)
            }
        }
    }
    
    //request 1 pokemon
    fileprivate func loadPokemon(_ id: Int)
    {
        requestPokedex.getPokemon(id: id) { (response) in
            switch response
            {
            case .success(let model):
                //Adiciona o pokemon em nossa variavel
                self.pokemons.append(model)
                //Manda fazer load da imagem do pokemon carregado
                self.loadImagePokemon(url: model.urlImage)
            case .serverError(let description):
                print(description)
            case .timeOut(let description):
                print(description)
            case .noConnection(let description):
                print(description)
            }
        }
    }

    //request imagem pokemon
    fileprivate func loadImagePokemon(url: String)
    {
        requestPokedex.getImagePokemon(url: url) { (response) in
            switch response
            {
            case .success(let model):
                //Salva a imagem em nossa variavel
                self.imagePokemons.append(model)
                //If inline
                //Se o ultimo pokemon carregado ainda nao for o ultimo pokemon da lista de todos pokemons que nos temos, mandamos ele carregar o proximo pokemon
                //Se já tiver sido carregado todos os pokemons eu mando atualizar a tabela
                self.pokemons.last!.id < self.resultCount ?
                    self.loadPokemon(self.pokemons.last!.id + 1) :
                    self.tableView.reloadData()
            case .noConnection(let description):
                print(description)
            case .serverError(let description):
                print(description)
            case .timeOut(let description):
                print(description)
            }
        }
    }
    
    //quantos itens na tabela
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //Se tiver próxima página será adicionado a quantidade de resultados mais uma célula que irá carregar mais pokemons
        return resultModel?.next == "" ? resultCount : resultCount + 1
    }
    
    //recarrega pokemons
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == resultCount {
            loadPokedex(url:resultModel?.next)
        }
    }

    //visual das celulas da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Se for a ultima célula carrego a célula de load
        if indexPath.row == resultCount {
            guard let cellLoad =    tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as? LoadViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            }
            //Inicio a animação de load
            cellLoad.loadActivity.startAnimating()
            return cellLoad
        }
        //Se tiver tudo ok carrego a célula de pokemon
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
        }
        //Configuro o visual da célula
        cell.configureCell(withModel: pokemons[indexPath.row],   pokemonSpriteData: imagePokemons[indexPath.row])
        return cell
    }

    
}
