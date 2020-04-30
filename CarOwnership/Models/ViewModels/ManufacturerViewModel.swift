//
//  ManufactrurerViewModel.swift
//  AEFetchedResultsControllerApp
//
//  Created by Amirreza Eghtedari on 21.04.20.
//  Copyright © 2020 Amirreza Eghtedari. All rights reserved.
//

import Foundation

struct ManufacturerViewModel {
	
	var modelID: 	String?
	
    var name:       String
    var ranking:    Int

    init(by manufacturer: Manufacturer) {
        self.name       = manufacturer.name
        self.ranking    = manufacturer.ranking
    }
    
    func makeManufacturer() -> Manufacturer {
		return Manufacturer(modelID: self.modelID,
							name: self.name,
							ranking: self.ranking)
    }
    
    func update(manufacturer: inout Manufacturer) {
		manufacturer.modelID 	= self.modelID
        manufacturer.name       = self.name
        manufacturer.ranking    = self.ranking
    }
}

