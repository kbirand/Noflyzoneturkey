//
//  ViewController.swift
//  noflyzoneturkey
//
//  Created by Koray Birand on 30/04/16.
//  Copyright © 2016 Koray Birand. All rights reserved.
//


//var ap = []

import Cocoa
import MapKit
import CoreLocation
import AVFoundation
import Foundation
import CoreGraphics




extension NSColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


class ViewController: NSViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var cCode : Int = 0xffffff
    var airportLocations : NSMutableArray = NSMutableArray()
    var airportHotZonez : [MKCircle]!
    var airportCircle : MKCircle = MKCircle()
    var turkeyAirports : NSArray!
    var searchRadius : Double = 150000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        let dataFile : String = Bundle.main.path(forResource: "kb", ofType: "txt")!
        
        var airportsFile : NSString!
        let myFile : URL = URL(fileURLWithPath: dataFile)
        
        
        
        
        do {
            airportsFile = try NSString(contentsOf: myFile, encoding: String.Encoding.utf8.rawValue)

        } catch {print("fileno")}
        
        
        
        //print(airportsFile)
        
        let airportsArray = airportsFile!.components(separatedBy: "\n")
        
        
    
        
        
        let predicate : NSPredicate = NSPredicate (format: "SELF CONTAINS %@ or SELF CONTAINS %@", "AIRPORT", "HELIPORT")
        turkeyAirports = (airportsArray as NSArray).filtered(using: predicate) as NSArray
        
        
        
        for index in 0...turkeyAirports.count-1 {
           
            var airports = (turkeyAirports[index] as AnyObject).components(separatedBy: ",")
            
            
            var location = CLLocation()
            
            let lat = Double(airports[2])
            let lon = Double(airports[3])
            location = CLLocation(latitude: lat!, longitude: lon!)
            
            if index == 0 {
                print(lat)
                print(lon)
                print(location.coordinate)
            }
            
         
            let circle = MKCircle(center: location.coordinate, radius: 9000 as CLLocationDistance)
            self.mapView.add(circle)
            
            
            let a : Double = 41.078436
            let b : Double = 29.058982
            
            let homeGPSData = CLLocation(latitude: a, longitude: b)
          
            centerMapOnLocation(homeGPSData)
            
            
        }
        

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

    func centerMapOnLocation(_ location: CLLocation) {
        
        
        if location.coordinate.longitude != 0.0 {
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, searchRadius * 0.1, searchRadius * 0.1)
            mapView.setRegion(coordinateRegion, animated: false)
            //manager.stopUpdatingLocation()
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = NSColor.red
            circle.fillColor = NSColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 0.7
            return circle
        } else {
            return nil
        }
    }



}

