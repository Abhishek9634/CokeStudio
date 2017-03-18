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

class CKSongsListVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CKTableCellDelegate, URLSessionDownloadDelegate ,URLSessionDelegate {

    
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
        self.setUpNavigation()
    }

    func setUpNavigation() {
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                                        NSFontAttributeName: UIFont(name: "Helvetica", size: 18) as Any]
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 233.0/255.0, green: 57.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        self.navigationController!.navigationBar.tintColor = UIColor.white
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
        tableCell.playButton.isEnabled = (song.localURL != nil)
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let song = filteredList?.object(at: indexPath.row) as! CKSong
        print("SELECTED_SONG : \((song.song)!)")
    }
    
    //====================================================================================================================================
    // TABLE CELL DELEGATE : TAP CALLBACKS
    //====================================================================================================================================
    
    internal func didTapFavouriteButton(cell: CKTableCell) {
        
        /************************************************************
         TAP FOR FAVOURITE SONG
         *************************************************************/
        
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
        
        /**************************************************************************
         TAP FOR PLAYING : THIS WILL ACTIVE ONLY WHEN SONG DOWNLOAD COMPLETELY
         ***************************************************************************/
        
        let indexPath = self.songTableView.indexPath(for: cell)
        let song = filteredList?.object(at: (indexPath?.row)!) as! CKSong
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let songDetailVC = storyBoard.instantiateViewController(withIdentifier: "CKSongDeatialVC") as! CKSongDeatialVC
        songDetailVC.song = song
        self.navigationController?.pushViewController(songDetailVC, animated: true)
    }
    
    internal func didTapDownloadButton(cell: CKTableCell) {
        
        /**************************************************************************
         TAP FOR DOWNLOAD : DOWNLOAD REMOTE DATA AND SAVE TO DOC DIRECTORY
         ***************************************************************************/
        cell.loadingIcon.startAnimating()
        let indexPath = self.songTableView.indexPath(for: cell)
        let song = filteredList?.object(at: (indexPath?.row)!) as! CKSong
        
        let songURL = NSURL(string : song.url as! String)
        
        let downloadTask : URLSessionDownloadTask = self.downloadsSession.downloadTask(with: songURL as! URL) { (location, response, error) in
            
            if (error == nil) {
                
                let time = NSNumber(value:(NSDate().timeIntervalSince1970 * 1000))
                let fileName = NSString(format:"%@_music.mp3",time)
                let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
                let destinationFileUrl = documentsUrl.appendingPathComponent(fileName as String)
                
                do {
                    try FileManager.default.copyItem(at: location!, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
                print("DOWNLOAD FINISHED \(location)")
                print("DOWNLOAD FINISHED \(destinationFileUrl)")
                
                song.localURL = destinationFileUrl.path as NSString?
            }
            DispatchQueue.main.async {
                cell.playButton.isEnabled = (song.localURL != nil)
                cell.loadingIcon.stopAnimating()
            }
        }
        
        downloadTask.resume()
    }
    
    //====================================================================================================================================
    // SONG DOWNLOAD TASK : NSURLSESSION
    //====================================================================================================================================
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
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
