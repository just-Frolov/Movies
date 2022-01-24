//
//  StoredMovieModel+CoreDataProperties.swift
//  Movies
//
//  Created by Данил Фролов on 24.01.2022.
//
//

import Foundation
import CoreData


extension StoredMovieModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredMovieModel> {
        return NSFetchRequest<StoredMovieModel>(entityName: "StoredMovieModel")
    }

    @NSManaged public var genreIDS: [Int]?
    @NSManaged public var id: Int32
    @NSManaged public var poster: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double

}

extension StoredMovieModel : Identifiable {

}
