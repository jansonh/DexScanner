//
//  DatabaseLoader.swift
//  DexScanner
//
//  Created by Janson Hendryli on 09/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseLoader {
    private var realm : Realm!
    
    init() {
        let realmPath = Bundle.main.url(forResource: "default", withExtension: "realm")!

        // Configure to read only as file located in Bundle is not writeable.
        let realmConfiguration = Realm.Configuration(fileURL: realmPath, readOnly: true)

        realm = try! Realm(configuration: realmConfiguration)
    }

    // Delete the previous realm database. Do not use it but to upgrade existing
    // database schema only.
    internal static func delete_previous_database() {
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {
            print(error)
        }
    }

    // Load the Pokémon data from the realm database.
    internal func loadPokemon() -> Results<Pokemon> {
        return realm.objects(Pokemon.self).sorted(byKeyPath: "dexNo", ascending: true)
    }
}
