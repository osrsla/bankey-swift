//
//  DecimalUtils.swift
//  Bankey
//
//  Created by SR on 2023/09/02.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
