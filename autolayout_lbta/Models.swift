//
//  Models.swift
//  Re-create-appstore
//
//  Created by Marcus Man on 29/4/2018.
//  Copyright © 2018 Marcus Man. All rights reserved.
//

import UIKit
import Foundation

class itemCategory: NSObject {
    var title: String?
    var icon: String?
    static func getItems() -> [itemCategory]{
        let dataSource = ["icon_1", "icon_2", "icon_3", ]
        let imageArray = ["profile", "selected", "search"]
        var arrayItems = [itemCategory]()
        for _ in 1...5 {
            for (index, item) in dataSource.enumerated(){
                let tempt = itemCategory()
                tempt.title = item
                tempt.icon = imageArray[index]
                arrayItems.append(tempt)
            }
        }
        return arrayItems
    }
}

class promotionImages: NSObject {
    var icon: String?
    static func getItems() -> [promotionImages]{
        let dataSource = ["p1", "p2", "p3"]
        var arrayItems = [promotionImages]()
        for (_, item) in dataSource.enumerated() {
            let tempt = promotionImages()
            tempt.icon = item
            arrayItems.append(tempt)
        }
        return arrayItems
    }
}
