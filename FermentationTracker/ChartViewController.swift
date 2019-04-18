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
    private func startObservingBeer() {
        assert(self.observerToken == nil)
        // I'm seeing view did appear when we aren't in windows...what???!
        if self.view.window != nil {
            self.observerToken = NotificationCenter.default.addObserver(forName: MainWindowController.selectedBeersChangedNote, object: self.mainWindowController, queue: nil) { [weak self] (Notification)  in
                self?.updateSelectedBeer()
            }
        }
        updateSelectedBeer()
    }
    
    private func stopObservingBeer() {
        if let observerToken = observerToken {
            NotificationCenter.default.removeObserver(observerToken)
            self.observerToken = nil
        }
    }
    
    override open func viewDidDisappear() {
        stopObservingBeer()
    }
    
    private func updateSelectedBeer() {
 
    }

    
    override open func viewDidAppear() {
        super.viewDidAppear()
        startObservingBeer()
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
        let ys2 = Array(1..<10).map { x in return cos(Double(x) / 2.0 / 3.141) }
        
        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(values: yse1, label: "Hello")
        ds1.colors = [NSUIColor.red]
        data.addDataSet(ds1)
        
        let ds2 = LineChartDataSet(values: yse2, label: "World")
        ds2.colors = [NSUIColor.blue]
        data.addDataSet(ds2)
        self.lineChartView.data = data
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        
        self.lineChartView.chartDescription?.text = "Linechart Demo"
    }
    
    override open func viewWillAppear()
    {
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}

