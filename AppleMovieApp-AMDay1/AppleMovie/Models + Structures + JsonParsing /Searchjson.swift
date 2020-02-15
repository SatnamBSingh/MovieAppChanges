//
//  Searchjson.swift
//  AppleMovie
//
//  Created by Captain on 17/01/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import Foundation

public class Searchjson {
    static let searchMoviesData = Searchjson()
    var searchedMovies = [AppleMoviesData]()

    func jsonURLS(string: String, page: Int, completetion : (Bool, AppleMoviesJsonModel?) -> ()) {
        let pageNum = String(page)

        let pathKey = "?api_key=60af9fe8e3245c53ad9c4c0af82d56d6&language=en-US&page=\(pageNum)&query=\(string)"
        let moviesURL = "https://api.themoviedb.org/3/search/movie" + pathKey
        
        if let url = URL(string: moviesURL) {
            if let data = try? Data(contentsOf: url){
                guard let model =  moviesJsonParsing(json: data) else {
                    completetion(false, nil)
                    return
                }
                completetion(true, model)
            }
        }
    }
    func moviesJsonParsing(json: Data) -> AppleMoviesJsonModel?{
        let decoder =  JSONDecoder()
        var searchmovies: AppleMoviesJsonModel?
        if let searchMoviesJsonData = try? decoder.decode(AppleMoviesJsonModel.self, from: json){
            searchmovies = searchMoviesJsonData
        }
        return searchmovies

    }
   
    
//    func SearchJsonParse(string: String, page: Int){
//        let spaceGapText = string.replacingOccurrences(of: " ", with: "+")
//        let searchUrl = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=60af9fe8e3245c53ad9c4c0af82d56d6&language=en-US&page=\(page)&query=\(spaceGapText)")!
//        let urlRequest = URLRequest(url: searchUrl)
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
//
//            if let error = error {
//                print(error.localizedDescription)
//            }else{
//                if let data = data{
//                    do{
//                        let decoder = JSONDecoder()
//                    let movieDetails = try decoder.decode(MoreResults.self, from: data)
//                        if let searchedMovies = movieDetails.results{
//                            if page == 1 {
//                                self.searchedMovies = searchedMovies
//                            }
//                            else{
//                                for movie in searchedMovies{
//                                    self.searchedMovies.append(movie)
//                                }
//                            }
//
//                        }
//
//                    }catch(let error){
//                        print(error.localizedDescription)
//                    }
//
//                }
//            }
//        }
//
//        dataTask.resume()
//    }

    
}
//let Pathkey = "?api_key=60af9fe8e3245c53ad9c4c0af82d56d6&language=en-US&page=1&query=Endgame"
//let moviesURL = "https://api.themoviedb.org/3/search/movie" + Moviescateogry + Pathkey
