//
//  CoreDataManager.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit
import CoreData


enum MovieValues: String {
    case id = "id"
    case name = "name"
    case posterImage = "posterImage"
}

class CoreDataManager: NSObject {
    
    let managedContext: NSManagedObjectContext
    
    let kEntityName: String = "Movie"
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.persistentContainer.viewContext
        super.init()
    }
    
    func addOrUpdateMovies(movies: Movies) {
        
        DispatchQueue.main.async() {
            for result in movies.results {
                
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: self.kEntityName)
                fetchRequest.predicate = NSPredicate(format: "id = %d", result.id!)
                
                do
                {
                    let test = try self.managedContext.fetch(fetchRequest)
                    
                    if test.count == 0 {
                        let movieEntity = NSEntityDescription.entity(forEntityName: self.kEntityName, in: self.managedContext)!
                        let movie = NSManagedObject(entity: movieEntity, insertInto: self.managedContext)
                        movie.setValue(result.id, forKey: MovieValues.id.rawValue)
                        movie.setValue(result.originalTitle, forKey: MovieValues.name.rawValue)
                        
                    }
                    do
                    {
                        try self.managedContext.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    func addMovieImage(movieImage: UIImage, id: Int?) {
        
        if let data = UIImagePNGRepresentation(movieImage), let id = id {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: kEntityName)
            fetchRequest.predicate = NSPredicate(format: "id = %d", id)
            
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                if test.count > 0 {
                    if let movie = test[0] as? NSManagedObject {
                        
                        movie.setValue(data, forKey: MovieValues.posterImage.rawValue)
                        
                        do
                        {
                            try managedContext.save()
                        }
                        catch
                        {
                            print(error)
                        }
                    }
                }
            }
            catch
            {
                print(error)
            }
        }
        
    }
    
    var shouldDisplayOfflineOption: Bool {
        
        var shouldDisplay: Bool = false
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: kEntityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            shouldDisplay = result.count > 0
            
        } catch {
            
            print(error)
        }
        return shouldDisplay
    }
    
    
    
    func retrieveMovies() -> [MovieCoreData] {
        
        var moviesCoreData: [MovieCoreData] = []
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: kEntityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let movieCoreData = MovieCoreData()
                movieCoreData.parseData(data: data)
                moviesCoreData.append(movieCoreData)
            }
            
        } catch {
            
            print(error)
        }
        return moviesCoreData
    }
}
