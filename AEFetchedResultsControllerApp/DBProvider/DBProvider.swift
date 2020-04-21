//
//  DBProvider02.swift
//  AEFetchedResultsControllerApp
//
//  Created by Amirreza Eghtedari on 17.04.20.
//  Copyright © 2020 Amirreza Eghtedari. All rights reserved.
//

import Foundation
import CoreData

class DBProvider: NSObject {
    
    var frc: NSFetchedResultsController<ManagedCar>!
    weak var delegate: DBProviderDelegate?
    
    override init() {
        
        super.init()
        
        NotificationCenter.default.addObserver(self,
                         selector: #selector(accountsUpdated(notification:)),
                         name: NSNotification.Name.NSManagedObjectContextDidSave,
                         object: DBManager.shared.context)

        
        let fetchRequest: NSFetchRequest<ManagedCar> = ManagedCar.fetchRequest()
        let predicate = NSPredicate(format: "owner != nil")
        fetchRequest.predicate = predicate
        let sort1 = NSSortDescriptor(key: #keyPath(ManagedCar.owner.name), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(ManagedCar.model), ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                         managedObjectContext: DBManager.shared.context,
                                         sectionNameKeyPath: #keyPath(ManagedCar.owner.name),
                                         cacheName: nil)
        frc.delegate = self
    }
    
    @objc func accountsUpdated(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            //InsertedObject
            if let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,  insertedObjects.count > 0 {
                
            }
            
            //DeletedObjects
            if let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,  deletedObjects.count > 0 {
                
            }
            
            //UpdatedObjects
            if let updatedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,  updatedObjects.count > 0 {
                
            }
        }
    }
}

extension DBProvider: DBProviderInterface {
    
    func relaodData() {
        do {
            try frc.performFetch()
            if frc.fetchedObjects?.count == 0 {
                initializeDatabase()
            } else {
                delegate?.providerDidReloadData(self)
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func initializeDatabase() {
        print(frc.sections!.count)
        guard frc.sections?.count == 0 else { return }
        
        //Manufacturer
        let kia =       ManagedManufacturer(contex: DBManager.shared.context, name: "Kia", ranking: 12)
        let toyota =    ManagedManufacturer(contex: DBManager.shared.context, name: "Toyota", ranking: 5)
        let porche =    ManagedManufacturer(contex: DBManager.shared.context, name: "Porche", ranking: 11)
        let bmw =       ManagedManufacturer(contex: DBManager.shared.context, name: "BMW", ranking: 7)
        
        let calendar =  Calendar.current
        
        //Amir
        let amirDate =  calendar.date(from: DateComponents(calendar: calendar, year: 1978, month: 11, day: 12))
        let amir =      ManagedPerson(context: DBManager.shared.context, name: "Amirreza", birthdate: amirDate!, cars: nil)
        let _ =         ManagedCar(contex: DBManager.shared.context, model: "Picanto", manufacturer: kia, mileage: 32000, owner: amir)
        let _ =         ManagedCar(contex: DBManager.shared.context, model: "Corrola", manufacturer: toyota, mileage: 800, owner: amir)
        
        //Nima
        let nimaDate =  calendar.date(from: DateComponents(calendar: calendar, year: 1982, month: 6, day: 1))
        let nima =      ManagedPerson(context: DBManager.shared.context, name: "Nima", birthdate: nimaDate!, cars: nil)
        let _ =         ManagedCar(contex: DBManager.shared.context, model: "Picanto", manufacturer: kia, mileage: 32000, owner: nima)
        let _ =         ManagedCar(contex: DBManager.shared.context, model: "Corrola", manufacturer: toyota, mileage: 800, owner: nima)
        
        //David
        let davidDate =     calendar.date(from: DateComponents(calendar: calendar, year: 1973, month: 1, day: 22))
        let _911Turbo =     ManagedCar(contex: DBManager.shared.context, model: "911 Turbo", manufacturer: porche, mileage: 256000, owner: nil)
        let _328 =          ManagedCar(contex: DBManager.shared.context, model: "328 M3", manufacturer: bmw, mileage: 22000, owner: nil)
        let _ =             ManagedPerson(context: DBManager.shared.context, name: "David", birthdate: davidDate!, cars: [_911Turbo, _328])
        
        DBManager.shared.saveContext()
    }
    
    func addSomething() {
        let firstCar = frc.object(at: IndexPath(row: 0, section: 0)) as ManagedCar
        let owner = firstCar.owner!
        let mercedes = ManagedManufacturer(contex: DBManager.shared.context, name: "Mercedes", ranking: 3)
        let _ = ManagedCar(contex: DBManager.shared.context, model: "A 250", manufacturer: mercedes, mileage: 45, owner: owner)
    }
    
    func saveSomething() {
        DBManager.shared.saveContext()
    }
    
    func deleteObject(at indexPath: IndexPath) {
        
        let car = frc.object(at: indexPath)
        DBManager.shared.context.delete(car)
        DBManager.shared.saveContext()
    }
}

extension DBProvider: AEListModelProvider {
    
    typealias Model = Ownership
    
    var modelObjects: [Ownership]? {
        guard let objects = frc.fetchedObjects else {
            return nil
        }
        
//        return objects.compactMap {
//
//        }
        return nil
    }
    
    var modelSections: [AESectionInfo]? {
        return nil
    }
    
    var modelSctionIndexTitles: [String] {
        return ["Salam"]
    }
    
    func modelSection(forSectionIndexTitle title: String, at sectionIndex: Int) -> Int {
        return 0
    }
    
    func modelSectionIndexTitle(forSectionName sectionName: String) -> String? {
        return nil
    }
    
    func modelObject(at indexPath: IndexPath) -> Ownership {
        //Todo
    }

    func indexPath(forModelObject object: Ownership) -> IndexPath? {
        //Todo
    }
}

extension DBProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.providerWillChangeContent(self, frc: controller as! NSFetchedResultsController<ManagedCar>)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        delegate?.provider(self, frc: controller as! NSFetchedResultsController<ManagedCar>, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        delegate?.provider(self, frc: controller as! NSFetchedResultsController<ManagedCar>, didChange: sectionInfo, atSectionIndex: sectionIndex, for: type)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        delegate?.providerDidChangeContent(self, frc: controller as! NSFetchedResultsController<ManagedCar>)
    }
}
