//
//  ChartViewController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/6/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit
import Charts

open class ChartViewController: NSViewController
{
    @IBOutlet var lineChartView: LineChartView!
    
    
    private var observerToken: NSObjectProtocol?
    private func startObservingSelectedBeerChanged() {
        assert(self.observerToken == nil)
        // I'm seeing view did appear when we aren't in windows...what???!
        if self.view.window != nil {
            self.observerToken = NotificationCenter.default.addObserver(forName: MainWindowController.selectedBeersChangedNote, object: self.mainWindowController, queue: nil) { [weak self] (Notification)  in
                self?.updateSelectedBeer()
            }
        }
        updateSelectedBeer()
    }
    
    private func stopObservingSelectedBeerChanged() {
        if let observerToken = observerToken {
            NotificationCenter.default.removeObserver(observerToken)
            self.observerToken = nil
            self.selectedBeer = nil
        }
    }
    
    override open func viewDidDisappear() {
        stopObservingSelectedBeerChanged()
    }
    
    private var selectedBeer: Beer? {
        didSet {
            refreshChart()
        }
    }
    
    private func updateSelectedBeer() {
        let beers = self.mainWindowController.selectedBeers
        if beers.count == 1 {
            selectedBeer = beers.first
        } else {
            selectedBeer = nil
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        return FermentationTrackerApplication.appDelegate.persistentContainer
    }()
    
    func makeEntriesFetchedResultsControllerForBeer(_ beer: Beer) -> NSFetchedResultsController<FermentationEntry> {
        let fetchRequest: NSFetchRequest<FermentationEntry> = FermentationEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "beer", beer.objectID)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }

    
    var fetchedResultsController: NSFetchedResultsController<FermentationEntry>?

    private func refreshChart() {
        guard let beer = self.selectedBeer else {
            self.lineChartView.data = nil
            self.fetchedResultsController?.delegate = nil
            self.fetchedResultsController = nil
            return;
        }
        
        let data = LineChartData()
        var gravityDataEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        let controller = makeEntriesFetchedResultsControllerForBeer(beer)
        do {
            try controller.performFetch()
        } catch let error as NSError {
            // TODO: errors
            fatalError("Unresolved error \(error)")
            //            NSApp.presentError(error)
        }

        self.fetchedResultsController = controller
        // TODO: updating!!
        for fermentationEntry in controller.fetchedObjects! {
            let x = Double(fermentationEntry.timestamp!.timeIntervalSinceReferenceDate)
            let y = Double(fermentationEntry.gravity)
            let chartEntry = ChartDataEntry(x: x, y: y)
            gravityDataEntries.append(chartEntry)
        }

        
        let ds1 = LineChartDataSet(values: gravityDataEntries, label: "Gravity")
        ds1.colors = [NSUIColor.red]
        data.addDataSet(ds1)
        
        self.lineChartView.data = data

    }
    
    override open func viewDidAppear() {
        super.viewDidAppear()
        startObservingSelectedBeerChanged()
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
//        let ys2 = Array(1..<10).map { x in return cos(Double(x) / 2.0 / 3.141) }
//
//        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
//        let yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
//
//        let data = LineChartData()
//        let ds1 = LineChartDataSet(values: yse1, label: "Hello")
//        ds1.colors = [NSUIColor.red]
//        data.addDataSet(ds1)
//
//        let ds2 = LineChartDataSet(values: yse2, label: "World")
//        ds2.colors = [NSUIColor.blue]
//        data.addDataSet(ds2)
//        self.lineChartView.data = data
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        
        self.lineChartView.chartDescription?.text = "Linechart Demo"
    }
    
    override open func viewWillAppear()
    {
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}

extension ChartViewController: NSFetchedResultsControllerDelegate {
    
    
}
