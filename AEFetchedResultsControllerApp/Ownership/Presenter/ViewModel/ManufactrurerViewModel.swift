//
//  ManufactrurerViewModel.swift
//  AEFetchedResultsControllerApp
//
//  Created by Amirreza Eghtedari on 21.04.20.
//  Copyright © 2020 Amirreza Eghtedari. All rights reserved.
//

import Foundation

struct ManufacturerViewModel {
    var name:       String
    var ranking:    Int

    init(by manufacturer: Manufacturer) {
        self.name       = manufacturer.name
        self.ranking    = manufacturer.ranking
    }
}

