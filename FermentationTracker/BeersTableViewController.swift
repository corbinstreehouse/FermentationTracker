//
//  BeersTableViewController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

extension NSViewController {
    var mainWindowController: MainWindowController {
        get {
            // FAIL if we aren't in a window; maybe i should push the logic into a view controller
            return self.view.window!.windowController as! MainWindowController
        }
    }
}

class BeersTableViewController: FetchedResultsTableViewController<Beer> {
    
    func makeBeersFetchedResultsController() -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isTracking", ascending: false),
                                        NSSortDescriptor(key: "creationOrder", ascending: false),
                                        NSSortDescriptor(key: "fermentationDataProvider", ascending: true)];
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
    override func viewWillAppear() {
        self.fetchedResultsController = makeBeersFetchedResultsController()
        super.viewWillAppear()
        selectFirstRowIfNeeded()
    }
    
    private func getSelectedBeers() -> [Beer] {
        guard let allBeers = self.fetchedResultsController?.fetchedObjects else { return [] }
        var result: [Beer] = Array()
        // There has to be a better/faster way to do this
        for index in tableView.selectedRowIndexes {
            let beer = allBeers[index]
            result.append(beer)
        }
        return result
    }
    
    private func updateSelectedBeers() {
        self.mainWindowController.selectedBeers = self.getSelectedBeers()
    }

    // NSTableViewDelegate
    @objc func tableViewSelectionDidChange(_ notification: Notification) {
        updateSelectedBeers()
    }
    
    override func deleteBackward(_ sender: Any?) {
        let selectedBeers = self.mainWindowController.selectedBeers
        let context = self.persistentContainer.viewContext
        for beer in selectedBeers {
            context.delete(beer)
        }
    }

}
