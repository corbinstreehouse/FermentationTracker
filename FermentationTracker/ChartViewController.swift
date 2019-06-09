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

        
        let gravityDataSet = LineChartDataSet(values: gravityDataEntries, label: "Gravity")
        gravityDataSet.colors = [NSUIColor.blue]
        gravityDataSet.drawCirclesEnabled = false
        gravityDataSet.drawValuesEnabled = false
        
        
        data.addDataSet(gravityDataSet)
        
        self.lineChartView.data = data

    }
    
    override open func viewDidAppear() {
        super.viewDidAppear()
        startObservingSelectedBeerChanged()
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        

        self.lineChartView.gridBackgroundColor = NSUIColor.white
        self.lineChartView.pinchZoomEnabled = true

        // Gravity axis (left side)
        let leftAxis = self.lineChartView.getAxis(.left)
        leftAxis.axisMinimum = 1.0 // Gravity min
        leftAxis.axisMaximum = 1.050
        leftAxis.labelCount = 5
        
        // Temp axis (right side)
        // disabled for now
        let rightAxis = self.lineChartView.getAxis(.right)
        rightAxis.drawGridLinesEnabled = false
        
        // Bottom axis, date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let bottomAxis = self.lineChartView.xAxis
        bottomAxis.labelPosition = .bottom
        
        bottomAxis.valueFormatter = DefaultAxisValueFormatter(block: { (_ value: Double,
            _ axis: AxisBase?) -> String in
            let d: Date = Date(timeIntervalSinceReferenceDate: value)
            return dateFormatter.string(from: d)
        })
        
        self.lineChartView.chartDescription?.text = ""
    }
    
    override open func viewWillAppear()
    {
    }
}

extension ChartViewController: NSFetchedResultsControllerDelegate {
    
    
}
