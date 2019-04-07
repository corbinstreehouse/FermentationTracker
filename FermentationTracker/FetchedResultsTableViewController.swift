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

class SafeResizingHeaderView: NSTableHeaderView {
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
}


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
        super.viewWillAppear()
    }
    
    // NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO: if the user is resizing the header while we get an update, it will screw things up. we'll have to pause and aggregate changes until the header resize is done, and then fix everything up at the end. Stupid bugs in tableview!
        switch (type) {
        case .insert:
            let rows = IndexSet(integer: newIndexPath!.item)
            tableView.insertRows(at: rows, withAnimation: .effectFade)
        case .delete:
            let rows = IndexSet(integer: indexPath!.item)
            tableView.removeRows(at: rows, withAnimation: .effectFade)
        case .move:
            let oldRow = indexPath!.item
            let newRow = newIndexPath!.item
            tableView.moveRow(at: oldRow, to: newRow)
        case .update:
            // We use bindings, so I don't think we have to do anything here
            break
        }
    }
    
    // NSTableViewDataSource
    @objc func numberOfRows(in tableView: NSTableView) -> Int {
        guard let object = self.fetchedResultsController?.fetchedObjects else { return 0 }
        return object.count
    }
    
    @objc func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let result = self.fetchedResultsController?.fetchedObjects![row]
        return result
    }
    
    @objc func tableViewColumnDidResize(_ notification: Notification) {
    
    }
    
}

