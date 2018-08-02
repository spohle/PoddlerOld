//
//  EpisodesController.swift
//  Poddler
//
//  Created by Sven Pohle on 7/13/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import CoreData

class EpisodesController: UITableViewController {
    
    var episodes = [Episode]()
    var subscribed:Bool = false
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            
            guard let feedUrl = podcast?.feedUrl else { return }
            APIService.shared.fetchEpisodes(baseUrl: feedUrl) { (episodes) in
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let cellId = "podcastCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favImage = UIImage(named: "favempty")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favImage, style: .plain,
                                                            target: self, action: #selector(favPodcast))
        
        getSubscribedStatus()
        setupTableView()
    }
    
    func getSubscribedStatus() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let author = data.value(forKey: "author") as! String
                
                if name == podcast?.trackName && author == podcast?.artistName {
                    self.subscribed = data.value(forKey: "subscribed") as! Bool
                    updateSubscribedStatus()
                }
            }
        } catch {
            print("failed!")
        }
    }
    
    func updateSubscribedStatus() {
        var favImage = UIImage(named: "favempty")
        if self.subscribed == true {
            favImage = UIImage(named: "fav")
        }
        navigationItem.rightBarButtonItem?.image = favImage
    }
    
    @objc func favPodcast() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        self.subscribed = !self.subscribed
        updateSubscribedStatus()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.predicate = NSPredicate(format: "name = %@", podcast?.trackName ?? "")
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let managedObject = result[0] as! NSManagedObject
                managedObject.setValue(self.subscribed, forKey: "subscribed")
                
                saveContext(context: context)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "CD_Podcast", in: context)
                let newPodcast = NSManagedObject(entity: entity!, insertInto: context)
                newPodcast.setValue(podcast?.trackName, forKey: "name")
                newPodcast.setValue(podcast?.artistName, forKey: "author")
                newPodcast.setValue(self.subscribed, forKey: "subscribed")
                
                saveContext(context: context)
            }
        } catch {
            
        }
        
    }
    
    fileprivate func saveContext(context:NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}
