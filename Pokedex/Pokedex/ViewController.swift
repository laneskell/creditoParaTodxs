//
//  ViewController.swift
//  Pokedex
//
//  Created by Kell Lanes on 06/07/21.
//

import UIKit

class ViewController: UIViewController {

    //Variavel responsvel por realizar todos os request
    let request = ResquestPokedex()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showPokedex()
    }
    
    func showPokedex()
    {
        //Passando nil como URL ele vai pegar a URL padrão
        request.getAllPokemons(url: nil)
        { (response) in
            switch response
            {
            case .success(let model):
                //Print do model
                print("X GET ALL POKEMONS \(model) \n")
                //Chamo a proxima função para exibir um pokemon especifico
                self.showPokemons()
            case .serverError(let description):
                print("Server Erro \(description)")
            case .noConnection(let description):
                print("No Connection \(description)")
            case .timeOut(let description):
                print("Time Out \(description)")
            }
        }
    }
    
    
    func showPokemons()
    {
        //Um id é passado para que busque um pokemon especifico
        request.getPokemon(id: 1)
        { (response) in
            switch response
            {
            case .success(let model):
                //Print do model do pokemon
                print("Y GET POKEMON \(model) \n")
                //Chamo a proxima função para exibir a imagem
                self.showImagePokemon(urlImage: model.urlImage)
            case .serverError(let description):
                print("Server Erro \(description)")
            case .noConnection(let description):
                print("No Connection \(description)")
            case .timeOut(let description):
                print("Time Out \(description)")
            }
        }
    }

    
    func showImagePokemon(urlImage:String)
    {
        //Passa a url da imagem
        request.getImagePokemon(url: urlImage)
        { (response) in
            switch response
            {
            case .success(let model):
                //Print do model da imagem
                print("Z IMAGE POKEMON \(model)")
            case .serverError(let description):
                print("Server Erro \(description)")
            case .noConnection(let description):
                print("No Connection \(description)")
            case .timeOut(let description):
                print("Time Out \(description)")
            }
        }
    }



}

