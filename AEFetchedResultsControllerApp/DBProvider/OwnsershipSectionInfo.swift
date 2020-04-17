//
//  CarSectionInfo.swift
//  AEFetchedResultsControllerApp
//
//  Created by Amirreza Eghtedari on 16.04.20.
//  Copyright © 2020 Amirreza Eghtedari. All rights reserved.
//

import Foundation

protocol OwnsershipSectionInfo {
    var numberOfObjects: Int { get }
    var objects: [Ownership]? { get }
    var name: String { get }
    var indexTitle: String? { get }
}