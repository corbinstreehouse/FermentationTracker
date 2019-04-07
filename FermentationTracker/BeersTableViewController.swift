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
            return self.view.window?.windowController as! MainWindowController
        }
    }
}

class BeersTableViewController: FetchedResultsTableViewController<Beer> {
    
    func makeBeersFetchedResultsController() -> NSFetchedResultsController<Beer> {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        let firstSortItem = NSSortDescriptor(key: "fermentationDataProvider", ascending: false)
        let secondSortItem = NSSortDescriptor(key: "creationOrder", ascending: false)
        fetchRequest.sortDescriptors = [firstSortItem, secondSortItem]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }
    
    override func viewWillAppear() {
        self.fetchedResultsController = makeBeersFetchedResultsController()
        super.viewWillAppear()
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
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        return tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil)
//    }
    
    @objc func tableViewSelectionDidChange(_ notification: Notification) {
        updateSelectedBeers()
    }

}
