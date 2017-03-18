//
//  CKSongsListVC.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit
import SDWebImage

class CKSongsListVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CKTableCellDelegate {

    
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var songSearchBar: UISearchBar!
    
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
    // TABLE VIEW DELEGATE
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
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let songDetailVC = storyBoard.instantiateViewController(withIdentifier: "CKSongDeatialVC") as! CKSongDeatialVC
        songDetailVC.song = song
        self.navigationController?.pushViewController(songDetailVC, animated: true)
    }
    
    //====================================================================================================================================
    // TABLE CELL DELEGATE
    //====================================================================================================================================
    
    internal func didTapFavouriteButton(cell: CKTableCell) {
        
        let indexPath = self.songTableView.indexPath(for: cell)
        let player = filteredList?.object(at: (indexPath?.row)!) as! CKSong
        player.favourite = !(player.favourite!)
        var image = UIImage(named: "favourite_default.png")
        
        if ((player.favourite!)) {
            image = UIImage(named: "favourite_set.png")
        }
        
        cell.favouriteButton?.setImage(image, for: .normal)
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
