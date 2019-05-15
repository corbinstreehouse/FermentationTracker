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
    
    private func updateSelectedBeer() {
        let beers = self.mainWindowController.selectedBeers
        if beers.count == 1 {
            self.representedObject = beers.first
        } else {
            self.representedObject = nil
        }
    }
    
    private var selectedBeer: Beer {
        get {
            return self.representedObject as! Beer
        }
    }
    
    private var observerToken: NSObjectProtocol?
    override func viewDidAppear() {
        super.viewDidAppear()
        assert(self.observerToken == nil)
        // I'm seeing view did appear when we aren't in windows...what???!
        if self.view.window != nil {
            self.observerToken = NotificationCenter.default.addObserver(forName: MainWindowController.selectedBeersChangedNote, object: self.mainWindowController, queue: nil) { [weak self] (Notification)  in
                self?.updateSelectedBeer()
            }
            updateSelectedBeer()
        }
    }
    
    override func viewDidDisappear() {
        if let observerToken = observerToken {
            NotificationCenter.default.removeObserver(observerToken)
            self.observerToken = nil
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
    
    private func getSelectedEntries() -> [FermentationEntry] {
        guard let fetchedResultsController = self.fetchedResultsController else { return [] }
        var result: [FermentationEntry] = Array()
        // There has to be a better/faster way to do this
        for index in tableView.selectedRowIndexes {
            let entry = fetchedResultsController.object(at: IndexPath(item: index, section: 0))
            result.append(entry)
        }
        return result
    }
    
    override func deleteBackward(_ sender: Any?) {
        let undoManager = self.view.window!.undoManager!
        undoManager.beginUndoGrouping()
        let context = self.persistentContainer.viewContext
        for entry in self.getSelectedEntries() {
            context.delete(entry)
        }
        undoManager.endUndoGrouping()
    }
}
