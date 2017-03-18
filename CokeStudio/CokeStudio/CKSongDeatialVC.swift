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
    @IBOutlet weak var songName: UILabel?
    @IBOutlet weak var artistsName: UILabel?
    @IBOutlet weak var songImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func rewindAction(_ sender: Any) {
    }
    
    @IBAction func playAction(_ sender: Any) {
    }
    
    @IBAction func pauseAction(_ sender: Any) {
    }
    
    @IBAction func stopAction(_ sender: Any) {
    }
   
    @IBAction func forwardAction(_ sender: Any) {
    }
}
