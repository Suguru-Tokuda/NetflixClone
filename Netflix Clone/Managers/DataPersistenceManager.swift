//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Suguru on 10/22/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    static let shared = DataPersistenceManager()
    
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func downloadTitle(width model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let context = getContext() else {
            return
        }

        let item = TitleItem(context: context)
        item.id = Int64(model.id)
        item.originalTitle = model.originalTitle
        item.originalName = model.originalName
        item.overview = model.overview
        item.posterPath = model.posterPath
        item.mediaType = model.mediaType
        item.releaseDate = model.releaseDate
        item.voteAverage = Double(model.voteAverage ?? 0.0)
        item.voteCount = Int64(model.voteCount ?? 0)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let context = getContext() else {
            completion(.failure(DatabaseError.failedToFetchData))
            return
        }
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let titles: [TitleItem] = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitle(with model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void ) {
        guard let context = getContext() else {
            completion(.failure(DatabaseError.failedToDeleteData))
            return
        }
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
