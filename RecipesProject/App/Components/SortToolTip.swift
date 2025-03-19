//
//  SortToolTip.swift
//  RecipesProject
//
//  Created by Pratyush on 3/18/25.
//

import TipKit
import Foundation

struct SortToolTip: Tip {

    var title: Text {
        Text("Sort the recipe")
    }

    var message: Text? {
        Text("Long press to see the sort options")
    }

    var rules: [Rule] {
        #Rule(Self.$hasViewedSortTip) { $0 == true }
    }

    @Parameter
    static var hasViewedSortTip: Bool = false
}
