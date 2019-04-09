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
        willSet {
            // Drop the delegate!
            fetchedResultsController?.delegate = nil
        }
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
    
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        print("section info change?")
//    }
    
    
    var insertionRows = IndexSet()
    var deletionRows = IndexSet()
    var moveRows = IndexSet() // TODO! Do moves.

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        print("beginUpdates")
        tableView.beginUpdates()
        insertionRows.removeAll()
        deletionRows.removeAll()
        moveRows.removeAll()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        print("endUpdates, delete: \(deletionRows) insert:\(insertionRows)")
        tableView.removeRows(at: deletionRows, withAnimation: .effectFade)
        tableView.insertRows(at: insertionRows, withAnimation: .effectFade)
        // TODO: moves!?
        insertionRows.removeAll()
        deletionRows.removeAll()

        tableView.endUpdates()
    }

    // NSFetchedResultsControllerDelegate
    // TODO: if the user is resizing the header while we get an update, it will screw things up. we'll have to pause and aggregate changes until the header resize is done, and then fix everything up at the end. Stupid bugs in tableview!
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch (type) {
        case .insert:
            let row = newIndexPath!.item
//            print("insert row: \(row)")
            insertionRows.insert(row)
        case .delete:
            let row = indexPath!.item
//            print("delete row: \(row)")
            deletionRows.insert(row)
        case .move:
            let oldRow = indexPath!.item
            let newRow = newIndexPath!.item
            tableView.moveRow(at: oldRow, to: newRow)
        case .update:
            // We use bindings; nothing needed here
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
    
    @objc func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as? NSTableCellView
        return result
    }

    
}

