//
//  FetchedResultsTableViewController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/6/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit
import CoreData


class FetchedResultsTableViewController<ResultType>: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSFetchedResultsControllerDelegate where ResultType : NSFetchRequestResult {
    
    @IBOutlet var tableView: NSTableView!
    
    var fetchedResultsController: NSFetchedResultsController<ResultType>? {
        didSet {
            fetchedResultsController?.delegate = self
            fetchAndReload()
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        return FermentationTrackerApplication.appDelegate.persistentContainer
    }()
    
    private func fetchAndReload() {
        do {
            try self.fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch let error as NSError {
            fatalError("Unresolved error \(error)")
            //            NSApp.presentError(error)
        }
    }
    
    override func viewWillAppear() {
    }
    
    // NSFetchedResultsControllerDelegate
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
            break
        }
    }
    
    // NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard let object = self.fetchedResultsController?.fetchedObjects else { return 0 }
        return object.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let result = self.fetchedResultsController?.fetchedObjects![row]
        return result
    }
    
}

