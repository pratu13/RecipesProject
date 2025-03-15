//
//  CustomFont.swift
//  RecipesProject
//
//  Created by Pratyush on 3/13/25.
//

import Foundation
import SwiftUI

extension Font {
    static func custom(_ font: AppFont, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
}

enum AppFont: String {
    case bold = "AvenirNextCondensed-Bold"
    case demibold = "AvenirNextCondensed-DemiBold"
    case medium = "AvenirNextCondensed-Medium"
    case ultralight = "AvenirNextCondensed-UltraLight"
    case heavy = "AvenirNextCondensed-Heavy"
    case regular = "AvenirNextCondensed-Regular"
    case black = "Avenir-Black"
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 60
        case .title: return 48
        case .title2: return 34
        case .title3: return 24
        case .headline, .body: return 18
        case .subheadline, .callout: return 16
        case .footnote: return 14
        case .caption, .caption2: return 12
        @unknown default:
            return 8
        }
    }
}


extension Font {
    static let regular = custom(.regular, relativeTo: .body)
    static let bold = custom(.bold, relativeTo: .largeTitle)
    static let medium = custom(.medium, relativeTo: .subheadline)
    static let ultralight = custom(.bold, relativeTo: .caption)
    static let heavy = custom(.bold, relativeTo: .caption)
    static let demibold = custom(.bold, relativeTo: .title2)
    static let black = custom(.bold, relativeTo: .headline)
}
