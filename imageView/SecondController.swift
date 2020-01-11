//
//  ViewController.swift
//  JSON DECODER
//
//  Created by Syed.Reshma Ruksana on 04/12/19.
//  Copyright © 2019 Syed.Reshma Ruksana. All rights reserved.


import UIKit
import AVKit

class SecondViewController: UIViewController
{

    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var actorLabel: UILabel!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var textView: UITextView!
    
    var playPauseButtonState = [ButtonState]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureStartUpUI()
        
        
        

       
    }
    
    
    func configureStartUpUI()
    {
        
        //Configuring Textview
        
        textView.isEditable = false
        textView.textColor = UIColor.white
        
        textView.backgroundColor = UIColor.black
        
        textView.text =  "STORY\n\n" + MovieDetails.movie.stories[MovieDetails.movie.selectedbutton!]
        
        
        //Configuring The Image Vie
        imageView.contentMode = .scaleToFill
        
        imageView.image = MovieDetails.movie.images[MovieDetails.movie.selectedbutton!]
        
        
        
        
        
        //Configuring Audio Control Buttons
        stackView.spacing = 30
        var i = 0
        for x in MovieDetails.movie.selectedSongTitle
        {
            let label = UILabel()
            label.layer.cornerRadius = 10
            label.text = x
            label.backgroundColor = .red
            label.textAlignment = .left
            label.textColor = UIColor.white
            stackView.addArrangedSubview(label)
            
            
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            
            
            
            let playAndPauseButton = UIButton()
            playAndPauseButton.backgroundColor = .blue
            playAndPauseButton.setTitle("Play", for: UIControl.State.normal)
            playAndPauseButton.layer.cornerRadius = 10
            playAndPauseButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            playAndPauseButton.addTarget(self, action: #selector(playAndPauseButtonEH(button:)), for: UIControl.Event.touchUpInside)
            playAndPauseButton.tag = i
            playPauseButtonState.append(ButtonState.OFF)
            i += 1
            contentView.addSubview(playAndPauseButton)
            
            
            playAndPauseButton.translatesAutoresizingMaskIntoConstraints = false
            playAndPauseButton.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -2.5).isActive = true
            playAndPauseButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            playAndPauseButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            playAndPauseButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
            
        }
        
        if(MovieDetails.movie.selectedSongTitle.count == 0)
        {
            let label = UILabel()
            label.layer.cornerRadius = 10
            label.text = "SONGS NOT AVAILABLE"
            label.backgroundColor = .white
            label.textAlignment = .center
            label.textColor = UIColor.black
            stackView.addArrangedSubview(label)
            
            
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
        }
        
        
        let watchTrailerButton = UIButton()
        watchTrailerButton.setTitle("Watch Trailer", for: UIControl.State.normal)
        watchTrailerButton.backgroundColor = UIColor.red
        watchTrailerButton.layer.cornerRadius = 13
        watchTrailerButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        watchTrailerButton.addTarget(self, action: #selector(watchTrailerButtonEH), for: UIControl.Event.touchUpInside)
        stackView.addArrangedSubview(watchTrailerButton)
        
        
        //Assigning Movie Name To Label
        movieNameLabel.text = MovieDetails.movie.movieTitle[MovieDetails.movie.selectedbutton!]
        
        
        //Assigning Actor Name To Actor Label
        actorLabel.text! += "\n"
        for x in MovieDetails.movie.actors[MovieDetails.movie.selectedbutton!]
        {
            actorLabel.text! += "\n" + x
        }
        

        
        
    }
    
    
    
    
    
    
    
    
    
    
    @objc func watchTrailerButtonEH()
    {
        let targetVC = AVPlayerViewController()
        
        targetVC.player = MovieDetails.movie.video
        
        self.present(targetVC, animated: true, completion: nil)
    }
    
    
    @objc func playAndPauseButtonEH(button:UIButton)
    {
        
        
        var isAnotherButtonOn:Bool = false
        for x in 0...playPauseButtonState.count-1
        {
            if(playPauseButtonState[x] == .ON && x != button.tag)
            {
                
                isAnotherButtonOn = true
            }
        }
        
        if(!isAnotherButtonOn)
        {
            
            if(playPauseButtonState[button.tag] == .OFF)
            {
                playPauseButtonState[button.tag] = .ON
                MovieDetails.movie.AVPlayerObjects[button.tag].play()
                button.setTitle("Pause", for: UIControl.State.normal)
                
            }
            else
            {
                playPauseButtonState[button.tag] = .OFF
                MovieDetails.movie.AVPlayerObjects[button.tag].pause()
                button.setTitle("Play", for: UIControl.State.normal)
            }
        }
        else
        {
            let alert = UIAlertController(title: "ALERT", message: "OOPS!! Two Songs Can't Play At A Time", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    

   
    @IBAction func backButtonEH(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    enum ButtonState:String
    {
        case ON
        case OFF
    }
    
}
