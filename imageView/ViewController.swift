//
//  ViewController.swift
//  JSON DECODER
//
//  Created by Syed.Reshma Ruksana on 04/12/19.
//  Copyright © 2019 Syed.Reshma Ruksana. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController
{

    var allButtonStack = [UIButton]()
    var allLabelStack = [UILabel]()
    var audioUrl = [[String]]()
    var videoUrl = [String]()
    let homeImageView = UIImageView()
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        loadBasicUIObjects()
        
    
        
        
    }
    
    
    
    //Load Basic UI Objects
    func loadBasicUIObjects()
    {
        
        
        
        //Stack View
        stackView.spacing = 20
        
        
        
        
        loadButton.layer.cornerRadius = 10
        
        loadButton.addTarget(self, action: #selector(loadButtonEH), for: .touchUpInside)
        //stackView.addArrangedSubview(loadButton)
        
        
        
        //HomeScreen image View
        
        homeImageView.image = UIImage(named: "sun")
        stackView.addArrangedSubview(homeImageView)
        
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        homeImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        homeImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        homeImageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -30).isActive = true
        homeImageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50).isActive = true
        
        
    }
    
    
    
    //Load Button Event Handler
    @objc func loadButtonEH()
    {
        loadAllUIObjects()
    }
    
    
    
    //Function Load All UIObjects As Per Server Response
    func loadAllUIObjects()
    {
        //Reset For Next Session
        resetForNextSession()
        
        
        //Removes Previous Session UIObjects
        removePreviousUIObjects()
        
        //Resetting For The Current Session
        allLabelStack = [UILabel]()
        allButtonStack = [UIButton]()
        audioUrl = [[String]]()
        
        
        let data = fetchJson()
        var i = 0
        for x in data
        {
            
            
            //Fetching Video URL In String
            videoUrl.append(configureUrl(urlInString: (x.trailers!)[0]))
            print(videoUrl)
            
            //Fetching Audio URL In String
            var tempAudioArray = [String]()
            for k in (x.songs!)
            {
                
                tempAudioArray.append(k)
            }
            audioUrl.append(tempAudioArray)
            
           
            
            
            
            
            //Fetching image
            let image = fetchImage(urlInString: (x.posters!)[0])
            
            
            
            //Storing All Stories & Images In Singleton object
            MovieDetails.movie.images.append(image)
            MovieDetails.movie.stories.append(x.story ?? "STORY NOT AVAILABLE")
            
            
            
            //Configuring And Adding button To Stack view
            let button = UIButton()
            button.setImage(image, for: UIControl.State.normal)
            button.contentMode = .scaleToFill
            button.tag = i
            i += 1
            button.addTarget(self, action: #selector(imageButtonEH(button:)), for: UIControl.Event.touchUpInside)
            allButtonStack.append(button)
            
            //Autolayout Constraits For button
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 300).isActive = true
            stackView.addArrangedSubview(button)
            
            
            
            //Configuring And Adding label To Stack view
            let label = UILabel()
            label.text = x.title!
            label.textColor = .white
            label.textAlignment = .center
            allLabelStack.append(label)
            stackView.addArrangedSubview(label)
            MovieDetails.movie.movieTitle.append(label.text!)
            
           //Fetching Actor Details
            MovieDetails.movie.actors.append(x.actors!)
                
           
            
            
        }
        
        loadButton.setTitle("Load", for: UIControl.State.normal)
        
        homeImageView.removeFromSuperview()
    }
    
    
    
    //Resetting All The Properties Of Singleton Obj Data For New Session
    func resetForNextSession()
    {
        
        MovieDetails.movie.images = [UIImage]()
        MovieDetails.movie.stories = [String]()
        MovieDetails.movie.movieTitle = [String]()
        MovieDetails.movie.actors = [[String]]()
        
    }
    
    
    
    
    
    
    
    //Common event  handler for all movie poster button
    @objc func imageButtonEH(button:UIButton)
    {
    
        
        
        MovieDetails.movie.selectedbutton = button.tag
        
        
        //Resetting The Selected Song Title Array
        MovieDetails.movie.selectedSongTitle = [String]()
        
        storeSongNameOfSelectedMovie()
        
        MovieDetails.movie.AVPlayerObjects = [AVPlayer]()
        for x in audioUrl[button.tag]
        {
           
            
            MovieDetails.movie.AVPlayerObjects.append(generateAVPlayerObjectsFromUrlInString(urlInString: x))
            
            
        }
        
    
        
        MovieDetails.movie.video = fetchVideo(urlInString: videoUrl[MovieDetails.movie.selectedbutton!])
        
        
        let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        
        present(targetVC, animated: true, completion: nil)
    }
    
    
    
    
    
    func generateAVPlayerObjectsFromUrlInString(urlInString:String) -> AVPlayer
    {
        return AVPlayer(url: URL(string: configureUrl(urlInString: urlInString))!)
    }
    
    func fetchVideo(urlInString:String) -> AVPlayer
    {
       return AVPlayer(url: URL(string: urlInString)!)
    }
    
    
    
    
    
    //Configures The Url
    func configureUrl(urlInString:String) -> String
    {
        var tempUrl = urlInString
        
        tempUrl = "https://www.brninfotech.com/tws/" + tempUrl
        
        tempUrl = tempUrl.replacingOccurrences(of: " ", with: "%20")
        
        return tempUrl
        
    }
    
    
    
    
    //Removes Previous Session UIObjects
    func removePreviousUIObjects()
    {
        for (x,y) in zip(allLabelStack,allButtonStack)
        {
            
            x.removeFromSuperview()
            y.removeFromSuperview()
        }
    }
    
    
    
    //Stores All The Song Names
    func storeSongNameOfSelectedMovie()
    {
        for x in self.audioUrl[MovieDetails.movie.selectedbutton!]
        {
           if let index = (x.range(of: "-")?.upperBound)
            {
               MovieDetails.movie.selectedSongTitle.append(String(x.suffix(from: index)))
            }
        }
        
    }
    
    
    
    
    
    //Function To fetch UIImage object
    func fetchImage(urlInString:String) -> UIImage
    {
        
        let url = URL(string: configureUrl(urlInString: urlInString))!
        var image:UIImage!
        do
        {
            let imageInFormOfData = try Data(contentsOf: url)
            
            image = UIImage(data: imageInFormOfData)
            
        }
        catch
        {
            print("Failed To Get Image")
        }
        
        return image
    }
    
    
    //Fetch Json Data
    func fetchJson() -> [Movie]
    {
        
        var convertedData:[Movie]?
        
        let dataTaskObj=URLSession.shared.dataTask(with: URL(string: "https://www.brninfotech.com/tws/MovieDetails2.php?mediaType=movies")!){(data,connDetails,err) in
            
            
            do
            {
                convertedData = try JSONDecoder().decode([Movie].self, from: data!)
                
                
            }
            catch
            {
                print("Failed")
            }
            
            
            
        }
        dataTaskObj.resume()
        
        while convertedData == nil
        {
            
        }
        
        
        return convertedData!
    }
}
    
    



