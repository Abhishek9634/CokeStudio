//
//  CKWelcomeVC.swift
//  CokeStudio
//
//  Created by Abhishek Thapliyal on 3/18/17.
//  Copyright © 2017 Abhishek Thapliyal. All rights reserved.
//

import UIKit

class CKWelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CKNetworkManager().getSongs { (arrayList, error) in
            
             DispatchQueue.main.async {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let navigationVC = storyBoard.instantiateViewController(withIdentifier: "CKNavigationVC") as! UINavigationController
                
                let viewArray = navigationVC.viewControllers as NSArray
                let songListVC = viewArray.object(at: 0) as! CKSongsListVC
                songListVC.songList = NSMutableArray(array: arrayList!)
                
                self.present(navigationVC, animated: true, completion: nil)
            }
        }
    }

}

