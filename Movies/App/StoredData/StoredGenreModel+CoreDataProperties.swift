//
//  StoredGenreModel+CoreDataProperties.swift
//  Movies
//
//  Created by Данил Фролов on 25.01.2022.
//
//

import CoreData


extension StoredGenreModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredGenreModel> {
        return NSFetchRequest<StoredGenreModel>(entityName: "StoredGenreModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?

}

extension StoredGenreModel : Identifiable {

}
