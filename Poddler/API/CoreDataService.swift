//
//  CoreDataService.swift
//  Poddler
//
//  Created by Pohle, Sven on 8/2/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    
    func getSubscribedPodcasts(completionHandler: @escaping ([Podcast]) -> ()) {
        var podcasts = [Podcast]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let author = data.value(forKey: "author") as! String
                
                APIService.shared.fetchPodcasts(searchText: name) { (searchPodcasts) in
                    for searchPodcast in searchPodcasts {
                        if searchPodcast.trackName == name && searchPodcast.artistName == author {
                            podcasts.append(searchPodcast)
                        }
                    }
                    completionHandler(podcasts)
                }
            }
            
        } catch {
            
        }
    }
    
    func getSubscribedStatus(podcast: Podcast) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let author = data.value(forKey: "author") as! String
                
                if name == podcast.trackName && author == podcast.artistName {
                    return data.value(forKey: "subscribed") as! Bool
                } else {
                    return false
                }
            }
        } catch {
            print("getSubscribedStatus failed!")
            return false
        }
        
        return false
    }
    
    func updateSubscribedStatus(podcast: Podcast, subscribed: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.predicate = NSPredicate(format: "name = %@", podcast.trackName ?? "")
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let managedObject = result[0] as! NSManagedObject
                managedObject.setValue(subscribed, forKey: "subscribed")
                
                saveContext(context: context)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "CD_Podcast", in: context)
                let newPodcast = NSManagedObject(entity: entity!, insertInto: context)
                newPodcast.setValue(podcast.trackName, forKey: "name")
                newPodcast.setValue(podcast.artistName, forKey: "author")
                newPodcast.setValue(subscribed, forKey: "subscribed")
                
                saveContext(context: context)
            }
        } catch {
            
        }
    }
    
    func saveContext(context:NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
}
