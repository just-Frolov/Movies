//
//  StoredMovieModel+CoreDataProperties.swift
//  Movies
//
//  Created by Данил Фролов on 23.01.2022.
//
//

import Foundation
import CoreData


extension StoredMovieModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredMovieModel> {
        return NSFetchRequest<StoredMovieModel>(entityName: "StoredMovieModel")
    }

    @NSManaged public var poster: String?
    @NSManaged public var title: String?

}

extension StoredMovieModel : Identifiable {
    
}
