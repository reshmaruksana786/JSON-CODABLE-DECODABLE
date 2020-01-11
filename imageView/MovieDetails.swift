//
//  ViewController.swift
//  JSON DECODER
//
//  Created by Syed.Reshma Ruksana on 04/12/19.
//  Copyright © 2019 Syed.Reshma Ruksana. All rights reserved.
//
import UIKit
import AVKit

class MovieDetails: NSObject
{
   
    static let movie = MovieDetails()
    
    var images = [UIImage]()
    
    var titles:[String]?
    
    var AVPlayerObjects = [AVPlayer]()
    
    var video = AVPlayer()
    
    var selectedSongTitle = [String]()
    
    var stories = [String]()
    
    var movieTitle = [String]()
    
    var actors = [[String]]()
    
    
    
    var selectedbutton:Int?
    
    private override init()
    {
        super.init()
    }
    
}
