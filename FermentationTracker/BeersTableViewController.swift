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
    
    @IBOutlet var tableView: NSTableView!
    
    lazy var persistentContainer: NSPersistentContainer = {
        return FermentationTrackerApplication.appDelegate.persistentContainer
    }()

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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                let indexSet = IndexSet(integer: indexPath.startIndex) // corbin!! range..
                tableView.insertRows(at: indexSet, withAnimation: NSTableView.AnimationOptions.effectFade)
            }
            break
        case .delete:
//            if let indexPath = indexPath {
//                tableView.removeRows(at: [indexPath], withAnimation: NSTableView.AnimationOptions.effectFade)
//           }
            break
        default:
            print("................................corbin")
        }
    }

}

extension BeersTableViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let beers = self.beersFetchedResultsController.fetchedObjects else { return 0 }
        return beers.count
    }
    
}

extension BeersTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil)
    }

}
