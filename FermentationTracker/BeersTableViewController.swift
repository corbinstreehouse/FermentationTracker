//
//  BeersTableViewController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class BeersTableViewController: NSViewController {
    
    // Is this racy, in case the persistentContainer isn't loaded? Maybe only assign it to child view controllers after loaded, and push it down the tree from the window controller?
    lazy var beersFetchedResultsController: NSFetchedResultsController<Beer> = {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        let firstSortItem = NSSortDescriptor(key: "isTracking", ascending: false) // active tracking first
        let secondSortItem = NSSortDescriptor(key: "creationOrder", ascending: true) // sorted by creation
        fetchRequest.sortDescriptors = [firstSortItem, secondSortItem]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewWillAppear() {
        do {
            try self.beersFetchedResultsController.performFetch()
        } catch let error as NSError {
            NSApp.presentError(error)
        }
    }
}

extension BeersTableViewController: NSFetchedResultsControllerDelegate {
    
}

extension BeersTableViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let beers = self.beersFetchedResultsController.fetchedObjects else { return 0 }
        return beers.count
    }

}

extension BeersTableViewController: NSTableViewDelegate {
    
}
