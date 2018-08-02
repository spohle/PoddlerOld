//
//  FavoritesController.swift
//  Poddler
//
//  Created by Pohle, Sven on 8/1/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UICollectionViewController
{
    lazy var uiAddButton:UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "favorites")?.imageScaled(to: CGSize(width: view.frame.width, height: view.frame.width))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(searchForPodcastsCb), for: .touchUpInside)
        return button
    }()
    
    var favorites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavoritesFromModel()
        collectionView.backgroundColor = .lightGray
        setupUserInterface()
    }
    
    func loadFavoritesFromModel() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "subscribed") as! Bool)
            }
        } catch {
            print("failed!")
        }
    }
    
    
    fileprivate func setupUserInterface() {
        if(favorites.count <= 0) {
            view.addSubview(uiAddButton)
            uiAddButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            uiAddButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            uiAddButton.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
            uiAddButton.heightAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
            return
        }
    }
    
    @objc fileprivate func searchForPodcastsCb() {
        let searchController = PodcastsSearchController()
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}
