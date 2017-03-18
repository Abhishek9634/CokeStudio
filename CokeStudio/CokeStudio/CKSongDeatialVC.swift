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
    public var audioPlayerObj : AVAudioPlayer?
    
    @IBOutlet weak var songName: UILabel?
    @IBOutlet weak var artistsName: UILabel?
    @IBOutlet weak var songImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /************************************************************
         FETCHING WITH LOCAL URL
         *************************************************************/
         let songURL = CKUtility.localFilePathForUrl(previewUrl: self.song?.localURL as! String)
        
        do {
            /************************************************************
             CONFIGURING AUDIO SESSION AND INTIALIZING AUDIO PLAYER OBJECT
             *************************************************************/
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayerObj = try AVAudioPlayer(contentsOf: songURL!)
            self.audioPlayerObj?.prepareToPlay()
            self.audioPlayerObj?.play()
        } catch let error as NSError {
            
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /************************************************************
         INTIALIZING SUBVIEW VALUES
         *************************************************************/
        
        self.songName?.text = self.song?.song as String?
        self.artistsName?.text = self.song?.artists as String?
        if (song?.cover_image != nil) {
            let imageURL = NSURL(string : self.song?.cover_image as! String)
            self.songImage?.sd_setImage(with: imageURL as URL!, placeholderImage: UIImage(named: "music_default.png"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.audioPlayerObj?.stop()
    }
    
    //====================================================================================================================================
    // MUSIC BUTTON ACTIONS
    //====================================================================================================================================
    
    @IBAction func rewindAction(_ sender: Any) {
        
        /************************************************************
         SONG REWIND
         *************************************************************/
        var time = (self.audioPlayerObj?.currentTime)! as TimeInterval
        time = time - 3.0;
        if (time <= 0)
        {
            time = 0;
        }
        else{
            self.audioPlayerObj?.currentTime = time;
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        self.audioPlayerObj?.play()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        self.audioPlayerObj?.pause()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        self.audioPlayerObj?.stop()
    }
   
    @IBAction func forwardAction(_ sender: Any) {
        
        /************************************************************
         SONG FORWARD
         *************************************************************/
        var time = (self.audioPlayerObj?.currentTime)! as TimeInterval
        time = time + 3.0;
        if (time > (self.audioPlayerObj?.duration)!)
        {
            self.audioPlayerObj?.stop()
        }
        else{
            self.audioPlayerObj?.currentTime = time;
        }
    }
}
