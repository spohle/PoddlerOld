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
                let subscribed = data.value(forKey: "subscribed") as! Bool
                if subscribed == true {
                    let jsonData = data.value(forKey: "jsonData") as! Data
                    do {
                        let podcast = try JSONDecoder().decode(Podcast.self, from: jsonData)
                        podcasts.append(podcast)
                    } catch {
                        
                    }
                }
            }
            completionHandler(podcasts)
            
        } catch {
            
        }
    }
    
    func getSubscribedStatus(podcast: Podcast) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.returnsObjectsAsFaults = false
        do {
            let queryResult = try context.fetch(request)
            for element in queryResult {
                let data = element as! NSManagedObject
                let name = data.value(forKey: "name") as! String
                let author = data.value(forKey: "author") as! String
                if name == podcast.trackName && author == podcast.artistName {
                    return data.value(forKey: "subscribed") as! Bool
                } else {
                    continue
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
        
        var jsonData:Data?
        do {
            jsonData = try JSONEncoder().encode(podcast)
        } catch {
            
        }
        
//        let jsonString = String(data: jsonData!, encoding: .utf8)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Podcast")
        request.predicate = NSPredicate(format: "name = %@", podcast.trackName ?? "")
        do {
            let result = try context.fetch(request)
            if result.count != 0 {
                let managedObject = result[0] as! NSManagedObject
                managedObject.setValue(subscribed, forKey: "subscribed")
                managedObject.setValue(jsonData, forKey: "jsonData")
                
                saveContext(context: context)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "CD_Podcast", in: context)
                let newPodcast = NSManagedObject(entity: entity!, insertInto: context)
                newPodcast.setValue(podcast.trackName, forKey: "name")
                newPodcast.setValue(podcast.artistName, forKey: "author")
                newPodcast.setValue(subscribed, forKey: "subscribed")
                newPodcast.setValue(jsonData, forKey: "jsonData")
                
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
