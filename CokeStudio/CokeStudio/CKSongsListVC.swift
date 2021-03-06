//
//  CKSongsListVC.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import MediaPlayer

class CKSongsListVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CKTableCellDelegate, URLSessionDownloadDelegate {

    
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var songSearchBar: UISearchBar!
    public var audioPlayerObj: AVAudioPlayer?
    
    var songList : NSMutableArray?                  // BASE ARRAY
    var filteredList : NSMutableArray?              // FILTER ARRAY
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        self.songSearchBar.delegate = self
        
        self.filteredList = NSMutableArray(array : self.songList!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //====================================================================================================================================
    // TABLE VIEW DELEGATE & DATA SOURCE
    //====================================================================================================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.filteredList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "CKTableCell") as! CKTableCell
        tableCell.delegate = self
        
        let song = self.filteredList?.object(at: indexPath.row) as! CKSong
        
        DispatchQueue.main.async {
            tableCell.songImgView?.layer.cornerRadius = (tableCell.songImgView?.frame.size.width)!/2;
            tableCell.songImgView?.layer.masksToBounds = true
        }
        
        tableCell.songName?.text = song.song as String?
        
        var image = UIImage(named: "favourite_default.png")
        if ((song.favourite!)) {
            image = UIImage(named: "favourite_set.png")
        }
        
        if (song.cover_image != nil) {
            
            let imageURL = NSURL(string : song.cover_image as! String)
            tableCell.songImgView?.sd_setImage(with: imageURL as URL!, placeholderImage: UIImage(named: "music_default.png"))
        }
        
        tableCell.artistLabel.text = song.artists as String?
        
        tableCell.favouriteButton?.setImage(image, for: .normal)
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let song = filteredList?.object(at: indexPath.row) as! CKSong
        print("SELECTED_SONG : \((song.song)!)")
    }
    
    //====================================================================================================================================
    // TABLE CELL DELEGATE
    //====================================================================================================================================
    
    internal func didTapFavouriteButton(cell: CKTableCell) {
        
        let indexPath = self.songTableView.indexPath(for: cell)
        let song = filteredList?.object(at: (indexPath?.row)!) as! CKSong
        song.favourite = !(song.favourite!)
        var image = UIImage(named: "favourite_default.png")
        
        if ((song.favourite!)) {
            image = UIImage(named: "favourite_set.png")
        }
        
        cell.favouriteButton?.setImage(image, for: .normal)
    }
    
    internal func didTapPlayButton(cell: CKTableCell) {
        
        let indexPath = self.songTableView.indexPath(for: cell)
        let song = filteredList?.object(at: (indexPath?.row)!) as! CKSong
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let songDetailVC = storyBoard.instantiateViewController(withIdentifier: "CKSongDeatialVC") as! CKSongDeatialVC
        songDetailVC.song = song
        self.navigationController?.pushViewController(songDetailVC, animated: true)
    }
    
    internal func didTapDownloadButton(cell: CKTableCell) {
        
        let indexPath = self.songTableView.indexPath(for: cell)
        let song = filteredList?.object(at: (indexPath?.row)!) as! CKSong
        
        let songURL = NSURL(string : song.url as! String)
        
        let downloadTask : URLSessionDownloadTask = self.downloadsSession.downloadTask(with: songURL as! URL)
        downloadTask.resume()
    }
    
    //====================================================================================================================================
    // SONG DOWNLOAD TASK
    //====================================================================================================================================
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "sessionID")
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)

        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
        print("PROGRESS \(String(format: "%.1f%% of %@", progress * 100, totalSize))")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let time = NSNumber(value:(NSDate().timeIntervalSince1970 * 1000))
        let fileName = NSString(format:"%@_music.mp3",time)
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName as String)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationFileUrl)
        } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
        }
        
        print("DOWNLOAD FINISHED \(location)")
        print("DOWNLOAD FINISHED \(destinationFileUrl)")
        
        let localUrl = self.localFilePathForUrl(previewUrl: destinationFileUrl.path)
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayerObj = try AVAudioPlayer(contentsOf: localUrl!)
            self.audioPlayerObj?.prepareToPlay()
            self.audioPlayerObj?.volume = 1.0
            self.audioPlayerObj?.play()
        } catch let error as NSError {
            
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    func localFilePathForUrl(previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), let lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.appendingPathComponent(lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    //====================================================================================================================================
    // SEARCH BAR DELEGATE
    //====================================================================================================================================
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.main.async {
            
            let predicate = NSPredicate(format: "song contains[cd] %@", searchText)
            self.filteredList?.removeAllObjects()
            let searcArray = self.songList?.filtered(using: predicate)
            self.filteredList?.addObjects(from: searcArray!)
            
            if (searchText.characters.count == 0) {
                
                self.filteredList?.addObjects(from: self.songList?.mutableCopy() as! [Any])
                searchBar.resignFirstResponder()
            }
            self.songTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("TEXT_DID_END")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
