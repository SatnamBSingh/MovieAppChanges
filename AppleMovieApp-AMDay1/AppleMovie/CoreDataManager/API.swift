//
//  APImanager.swift
//  AppleMovie
//
//  Created by Captain on 31/01/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import Foundation

enum moviesGroup: String{
    case nowPlayingMovies = "now_playing"
    case topRatedMovies = "top_rated"
    case popularMovies = "popular"
    case upcomingMovies = "upcoming"
}

class API {
    
    let moviesURL = "https://api.themoviedb.org/3/movie/"
    let apiKey = "api_key=60af9fe8e3245c53ad9c4c0af82d56d6"
    let imageUrl = "https://image.tmdb.org/t/p/w500"
    
    private var dB = DataBase.dbManager
    private var movieType: moviesGroup?
    
    
    // fetch movies from url
    func fetchingMovies(movieLanguage: String, pageNumber: Int, category: moviesGroup){
        self.movieType = category
        var url = moviesURL+"now_playing?"+apiKey+"&language="+movieLanguage+"&page=\(pageNumber)"
        switch category{
        case .nowPlayingMovies:
            url = moviesURL+"now_playing?"+apiKey+"&language="+movieLanguage+"&page=\(pageNumber)"
            
        case .popularMovies:
            url = moviesURL+"popular?"+apiKey+"&language="+movieLanguage+"&page=\(pageNumber)"
            
        case .topRatedMovies:
            url = moviesURL+"top_rated?"+apiKey+"&language="+movieLanguage+"&page=\(pageNumber)"
            
        case .upcomingMovies:
            url = moviesURL+"upcoming?"+apiKey+"&language="+movieLanguage+"&page=\(pageNumber)"
        }
        
        
        let urL = URL(string: url)
        fetchResults(url: urL!, completion: storeMoviedata)
    }
    
    
    func fetchResults(url: URL, completion:  @escaping (Data)->()){
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let data = data{
                    completion(data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    func storeMoviedata(data: Data){
        
        do{
            let decoder = JSONDecoder()
            let movieDetails = try decoder.decode(MoreResults.self, from: data)
            dB.insertData(movies: movieDetails.results!, category: movieType!)
            
        }
        catch(let error){
            print(error.localizedDescription)
        }
    }
    
    
}
