//
//  CKSongDeatialVC.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class CKSongDeatialVC: UIViewController {

    public var song : CKSong?
    public var audioPlayer : AVAudioPlayer?
    
    @IBOutlet weak var songName: UILabel?
    @IBOutlet weak var artistsName: UILabel?
    @IBOutlet weak var songImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rawURL : NSString = (self.song?.localURL != nil ? self.song?.localURL : self.song?.url)!
        let songURL = NSURL(string : rawURL as String)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: songURL as! URL)
        }
        catch let error as NSError {
            print("URL ERROR \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.songName?.text = self.song?.song as String?
        self.artistsName?.text = self.song?.artists as String?
        if (song?.cover_image != nil) {
            let imageURL = NSURL(string : self.song?.cover_image as! String)
            self.songImage?.sd_setImage(with: imageURL as URL!, placeholderImage: UIImage(named: "music_default.png"))
        }
    }
    
    //====================================================================================================================================
    // MUSIC BUTTON ACTIONS
    //====================================================================================================================================
    
    @IBAction func rewindAction(_ sender: Any) {
    }
    
    @IBAction func playAction(_ sender: Any) {
        self.audioPlayer?.play()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        self.audioPlayer?.pause()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        self.audioPlayer?.stop()
    }
   
    @IBAction func forwardAction(_ sender: Any) {
    }
}
