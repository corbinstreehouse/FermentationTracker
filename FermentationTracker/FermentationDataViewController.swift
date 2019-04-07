//
//  FermentationDataViewController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/6/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit
import CoreData

class FermentationDataViewController: FetchedResultsTableViewController<FermentationEntry> {
    
//    @IBOutlet var tableView: NSTableView! // Uncommend and use to trick IB so I can set the value in the parent class
    
    override var representedObject: Any? {
        didSet {
            refreshData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tableView.sortDescriptors.count == 0 {
            self.tableView.sortDescriptors = [self.tableView.tableColumns[0].sortDescriptorPrototype!]
        }
    }
    
    func makeFetchedResultsControllerFor(beer: Beer) -> NSFetchedResultsController<FermentationEntry> {
        let fetchRequest: NSFetchRequest<FermentationEntry> = FermentationEntry.fetchRequest()
        fetchRequest.sortDescriptors = self.tableView.sortDescriptors
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "beer", beer.objectID)

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }

    private func refreshData() {
        let beer = self.representedObject as? Beer
        if let beer = beer {
            fetchedResultsController = makeFetchedResultsControllerFor(beer: beer)
        } else {
            fetchedResultsController = nil
        }
    }
    
    @objc func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        refreshData()
    }
}
