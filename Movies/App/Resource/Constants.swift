//
//  Constants.swift
//  Movies
//
//  Created by Данил Фролов on 26.01.2022.
//

struct K {
    static let appName = "🍿Popular Movies"
    static let secondScreenName = "Movie Details"
    static let sectionIdentifier = "TableSection"
    
    struct MovieDetails {
        static let noDescription = "No Info"
        static let currency = "USD"
    }
    
    struct Assets {
        static let defaultImageName = "imageNotFound"
        static let starIcon = "star.fill"
    }
    
    struct NotificationCenter {
        static let network = "InternetСonnectionChanged"
    }
    
    struct SortType {
        static let byPopular = "popularity.desc"
        static let byRevenue = "revenue.desc"
        static let byAverageCount = "vote_count.desc"
    }
}
