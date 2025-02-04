//
//  String+Ext.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

import Foundation

extension String {
    var currencySymbol: String? {
        let locale = NSLocale(localeIdentifier: self)
        if locale.displayName(forKey: .currencySymbol, value: self) == self {
            let newLocale = NSLocale(localeIdentifier: self.dropLast() + "_en")
            return newLocale.displayName(forKey: .currencySymbol, value: self)
        }
        return locale.displayName(forKey: .currencySymbol, value: self)
    }
}
