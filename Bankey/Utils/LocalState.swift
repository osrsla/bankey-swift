//
//  LocalState.swift
//  Bankey
//
//  Created by SR on 2023/08/28.
//

import Foundation

public enum LocalState {
    private enum Keys: String {
        case hasOnboarded
    }

    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboarded.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboarded.rawValue)
        }
    }
}
