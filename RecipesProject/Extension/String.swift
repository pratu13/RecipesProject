//
//  String.swift
//  RecipesProject
//
//  Created by Pratyush on 3/15/25.
//

import Foundation

extension String {
    var withIndefiniteArticle: String {
        guard let firstLetter = self.lowercased().first else { return self }
        let vowels = "aeiou"
        let article = vowels.contains(firstLetter) ? "an" : "a"
        return "\(article) \(self)"
    }
}
