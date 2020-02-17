//
//  DataBase.swift
//  AppleMovie
//
//  Created by Captain on 31/01/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DataBase {
    
    static let dbManager = DataBase()
    static var nowPlayingMovies1 = [AppleMoviesData]()
    static var topRatedMovies1 = [AppleMoviesData]()
    static var popularMovies1 = [AppleMoviesData]()
    static var upcomingMovies1 = [AppleMoviesData]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var moviesData:AppleMoviesData?
    var movieType: moviesGroup?
    
    //Insert into coredata
    func insertData(movies: [AppleMoviesData],category : moviesGroup){
        DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let moviObj = NSEntityDescription.entity(forEntityName: "AppleMovies", in: context)!
            
            for data in movies
            {
                let results = NSManagedObject(entity: moviObj, insertInto: context)
                
                let populrty = data.popularity
                let votecnt = data.vote_count
                let orgTitle = data.title
                let orgLang = data.original_language
                let ids = data.id
                let img = data.poster_path
                let description = data.overview
                let releasedate = data.release_date
                let movisCatoegry = category.rawValue
                
                results.setValue(populrty, forKey: "popularity")
                results.setValue(votecnt, forKey: "vote_count")
                results.setValue(orgTitle, forKey: "original_title")
                results.setValue(orgLang, forKey: "original_language")
                results.setValue(ids, forKey: "id")
                results.setValue(img, forKey: "poster_path")
                results.setValue(description, forKey: "overview")
                results.setValue(releasedate, forKey: "releaseDate")
                results.setValue(movisCatoegry, forKey: "movieCateogory")
                
            }
            
            do
            {
                try context.save()
                print(context)
                print("insertion: successful")
                
                
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        
    }
   
    //Fetchdata from coredata
    func readFromCoreData(category: moviesGroup)
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppleMovies")
        
        switch category{
        case .nowPlayingMovies:
            request.predicate = NSPredicate(format: "movieCateogory == %@", argumentArray: ["now_playing"])
            DataBase.nowPlayingMovies1 = [AppleMoviesData]()
            
        case .popularMovies:
            request.predicate = NSPredicate(format: "movieCateogory == %@", argumentArray: ["popular"])
            DataBase.popularMovies1 = [AppleMoviesData]()
            
        case .topRatedMovies:
            request.predicate = NSPredicate(format: "movieCateogory == %@", argumentArray: ["top_rated"])
            DataBase.topRatedMovies1 = [AppleMoviesData]()
            
        case .upcomingMovies:
            request.predicate = NSPredicate(format: "movieCateogory == %@", argumentArray: ["upcoming"])
            DataBase.upcomingMovies1 = [AppleMoviesData]()
        }
        
        do
        {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                var fetchdata: AppleMoviesData = AppleMoviesData()
                
                fetchdata.popularity = data.value(forKey: "popularity") as? Double
                fetchdata.vote_count = data.value(forKey: "vote_count") as? Int
                fetchdata.title = data.value(forKey: "original_title") as? String
                fetchdata.original_language = data.value(forKey: "original_language") as? String
                fetchdata.id = data.value(forKey: "id") as? Int
                fetchdata.poster_path = data.value(forKey: "poster_path") as? String
                fetchdata.overview = data.value(forKey: "overview") as? String
                fetchdata.release_date = data.value(forKey: "releaseDate") as? String
                
                print(fetchdata.title)
                // print(fetchdata.overview)
                
                switch category{
                case .nowPlayingMovies:
                    DataBase.nowPlayingMovies1.append(fetchdata)
                case .popularMovies:
                    DataBase.popularMovies1.append(fetchdata)
                case .topRatedMovies:
                    DataBase.topRatedMovies1.append(fetchdata)
                case .upcomingMovies:
                    DataBase.upcomingMovies1.append(fetchdata)
                }
                
            }
            
        }
        catch
        {
            print(error.localizedDescription)
            
        }
    }
    
    
    
}


