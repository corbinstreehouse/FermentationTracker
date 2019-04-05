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
//        let firstSortItem = NSSortDescriptor(key: "isTracking", ascending: false) // active tracking first
        let firstSortItem = NSSortDescriptor(key: "creationOrder", ascending: false) // newest on top
        fetchRequest.sortDescriptors = [firstSortItem]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewWillAppear() {
        do {
            try self.beersFetchedResultsController.performFetch()
            tableView.reloadData()
        } catch let error as NSError {
            fatalError("Unresolved error \(error)")
//            NSApp.presentError(error)
        }
    }
}

extension BeersTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            let rows = IndexSet(integer: newIndexPath!.startIndex) // is this right? seems strange
            tableView.insertRows(at: rows, withAnimation: .effectFade)
        case .delete:
            let rows = IndexSet(integer: indexPath!.startIndex)
            tableView.removeRows(at: rows, withAnimation: .effectFade)
        case .move:
            let oldRow = indexPath!.startIndex
            let newRow = newIndexPath!.startIndex
            tableView.moveRow(at: oldRow, to: newRow)
        case .update:
            // We use bindings, so I don't think we have to do anything here
            let row = indexPath!.startIndex
            print("update... row \(row)");
            break
        }
    }

}

extension BeersTableViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let beers = self.beersFetchedResultsController.fetchedObjects else { return 0 }
        return beers.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let result = self.beersFetchedResultsController.fetchedObjects![row]
        
        return result
    }
    
}

extension BeersTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil)
    }

}
