//
//  NowPlayingVc.swift
//  AppleMovie
//
//  Created by Captain on 13/01/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit
import Kingfisher

class NowPlayingVc: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var getMoviesArrayData = [AppleMoviesData]()
    var movieDescription:String!
    var pagenumber = 1
    var api = API()
    var dataBase = DataBase()
    

    @IBOutlet weak var collectionviewnp: UICollectionView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionviewnp.delegate = self
        collectionviewnp.dataSource = self
        pagenumber = 1
        // JsonParseData.JsonMoviesData.JsonURLS(Moviescateogry: "now_playing", page: pagenumber)
        //getMoviesArrayData = JsonParseData.JsonMoviesData.MoviesDataArray
        // getPageCount(pagenumber: pagenumber, moviescateogry: "now_playing")
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isnowPlayingDownloaded") == false
        {
            defaults.set(true, forKey: "isnowPlayingDownloaded")
            self.api.fetchingMovies(movieLanguage: "en-US", pageNumber: pagenumber, category: .nowPlayingMovies)

        }
       // DispatchQueue.global().sync {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                let manageData = DataBase.dbManager
                manageData.readFromCoreData(category: .nowPlayingMovies)
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+5.0, execute: {
                self.getMoviesArrayData = DataBase.nowPlayingMovies1
                self.collectionviewnp.reloadData()
            })
        //}
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMoviesArrayData.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowplayingCollectionViewCell", for: indexPath) as! NowplayingCollectionViewCell
        cell.layer.cornerRadius = 25
        cell.movieimageview.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 20)
        cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.containerView.layer.cornerRadius = 15
       cell.containerView.layer.masksToBounds = true
        
        let moviestoShowinCell = getMoviesArrayData[indexPath.row]
        cell.movienamelabel.text = moviestoShowinCell.title
        cell.moviedescriptionlabel.text =  moviestoShowinCell.overview
        cell.releaselabel.text = moviestoShowinCell.release_date
        cell.ratinglabel.text = "\(moviestoShowinCell.vote_average ?? 0)"
        cell.votinglabel.text = "\(moviestoShowinCell.vote_count ?? 0)"
        cell.movieimageview.kf.setImage(with: URL(string: api.imageUrl + moviestoShowinCell.poster_path!), placeholder: nil, options: [], progressBlock: nil, completionHandler: nil)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.global().async {
             if indexPath.row == self.getMoviesArrayData.count-1 {
                self.pagenumber = self.pagenumber + 1
                self.api.fetchingMovies(movieLanguage: "en-US", pageNumber: self.pagenumber, category: .nowPlayingMovies)
                let manageData = DataBase.dbManager
                manageData.readFromCoreData(category: .nowPlayingMovies)
                self.getMoviesArrayData += DataBase.nowPlayingMovies1
                   DispatchQueue.main.async {
                self.collectionviewnp.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionviewnp.cellForItem(at: indexPath) as! NowplayingCollectionViewCell
        let movie = getMoviesArrayData[indexPath.row]
        movieDescription = currentCell.moviedescriptionlabel.text
        performSegue(withIdentifier: "details", sender: movie)
        
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: self.collectionviewnp.frame.width-40, height: self.collectionviewnp.frame.height-190)
    }
    
    
    let screenName = "NowPlaying"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "details") {
            guard let movie  = sender as? AppleMoviesData else{
                return
            }
            let detailsVc =  segue.destination as! DetailsViewController
            detailsVc.movie = movie
            detailsVc.getMovieCatoegry = screenName
        }
    }
    
//    func getPageCount(pagenumber: Int, moviescateogry: String){
//
//        self.api.fetchingMovies(movieLanguage: "en-US", pageNumber: pagenumber, category: .nowPlayingMovies)
//         self.getMoviesArrayData += DataBase.nowPlayingMovies1
//        //getMoviesArrayData += JsonParseData.jsonMoviesData.moviesDataArray
//        DispatchQueue.main.async {
//            self.collectionviewnp.reloadData()
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
}
