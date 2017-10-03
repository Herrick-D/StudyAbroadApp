//
//  DataModel.swift
//  Study Abroad App
//
//  Created by Dan Herrick on 9/26/17.
//  Copyright © 2017 Dan Herrick. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [PackingList]()
    
    init() {
        loadPackingLists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("PackingList.plist")
    }
    
    func savePackingLists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "PackingLists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadPackingLists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "PackingLists") as! [PackingList]
            unarchiver.finishDecoding()
            sortPackingLists()
        }
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = [ "PackingListIndex": -1, "FirstTime": true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedPackingList: Int {
        get {
            return UserDefaults.standard.integer(forKey: "PackingListIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "PackingListIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let packingList = PackingList(name: "List")
            lists.append(packingList)
            
            indexOfSelectedPackingList = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortPackingLists() {
        lists.sort(by: { packingList1, packingList2 in
            return packingList1.name.localizedStandardCompare(packingList2.name) == .orderedAscending })
    }
}
