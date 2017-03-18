//
//  CKSongsListVC.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit

class CKSongsListVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CKTableCellDelegate {

    
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var songSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.songTableView.delegate = self
        self.songTableView.dataSource = self
        self.songSearchBar.delegate = self
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
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "SBTableCell") as! SBTableCell
        tableCell.delegate = self
        
        let player = self.filteredList?.object(at: indexPath.row) as! SBPlayer
        
        DispatchQueue.main.async {
            tableCell.playerImageView?.layer.cornerRadius = (tableCell.playerImageView?.frame.size.width)!/2;
            tableCell.playerImageView?.layer.masksToBounds = true
        }
        
        tableCell.playerNameLabel?.text = player.name as String?
        
        var image = UIImage(named: "favourite_default.png")
        if ((player.favourite!)) {
            image = UIImage(named: "favourite_set.png")
        }
        
        if (player.image != nil) {
            
            let imageURL = NSURL(string : player.image as! String)
            tableCell.playerImageView?.sd_setImage(with: imageURL as URL!, placeholderImage: UIImage(named: "user_default.png"))
        }
        
        tableCell.favouriteButton?.setImage(image, for: .normal)
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let player = filteredList?.object(at: indexPath.row) as! SBPlayer
        print("SELECTED_PLAYER : \((player.name)!)")
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let playerDetailVC = storyBoard.instantiateViewController(withIdentifier: "SBPlayerDetailVC") as! SBPlayerDetailVC
        playerDetailVC.player = player
        self.navigationController?.pushViewController(playerDetailVC, animated: true)
    }
    
    //====================================================================================================================================
    // TABLE CELL DELEGATE
    //====================================================================================================================================
    
    internal func didTapFavouriteButton(cell: SBTableCell) {
        
        let indexPath = self.playerTableView.indexPath(for: cell)
        let player = filteredList?.object(at: (indexPath?.row)!) as! SBPlayer
        player.favourite = !(player.favourite!)
        var image = UIImage(named: "favourite_default.png")
        
        if ((player.favourite!)) {
            image = UIImage(named: "favourite_set.png")
        }
        
        SBDBManager().updatEntity(id: player.id, flag: player.favourite!)
        
        cell.favouriteButton?.setImage(image, for: .normal)
    }
    
    //====================================================================================================================================
    // SEARCH BAR DELEGATE
    //====================================================================================================================================
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.main.async {
            
            let predicate = NSPredicate(format: "name contains[cd] %@ OR country contains[cd] %@", searchText, searchText)
            self.filteredList?.removeAllObjects()
            let searcArray = self.playerList?.filtered(using: predicate)
            self.filteredList?.addObjects(from: searcArray!)
            
            if (searchText.characters.count == 0) {
                
                self.filteredList?.addObjects(from: self.playerList?.mutableCopy() as! [Any])
                searchBar.resignFirstResponder()
            }
            self.playerTableView.reloadData()
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
