//
//  Details.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on April 15, 2020

import Foundation

//MARK: - Details
public struct Details : Codable {

        public var actors : [String]?
        public var ageRating : String?
        public var assetSubtype : String?
        public var assetType : Int?
        public var audioLanguages : [String]?
        public var businessType : String?
//        public var channels : [AnyObject]?
        public var contentOwner : String?
        public var countries : [String]?
        public var coverImage : String?
        public var descriptionField : String?
        public var directors : [String]?
        public var drmKeyId : String?
        public var duration : Int?
        public var endCreditsMarker : String?
        public var endCreditsStartS : String?
        public var episodeNumber : Int?
        public var extended : Extended?
        public var genre : [Genre]?
        public var genres : [Genre]?
        public var hls : [String]?
        public var id : String?
        public var image : Image?
        public var imageUrl : String?
        public var isDrm : Int?
        public var languages : [String]?
        public var listImage : String?
        public var onAir : Bool?
        public var orderid : Int?
        public var originalTitle : String?
        public var rating : Int?
        public var related : [Related]?
        public var relatedChannelsSs : RelatedChannelsSs?
        public var relatedCollectionsSs : RelatedCollectionsSs?
        public var relatedMoviesSs : RelatedMoviesSs?
        public var relatedTvshowsSs : RelatedTvshowsSs?
        public var relatedVideosSs : RelatedVideosSs?
        public var releaseDate : String?
        public var showRelatedAll : Bool?
        public var skipAvailable : SkipAvailable?
        public var slug : String?
        public var subtitleLanguages : [String]?
        public var tags : [String]?
        public var title : String?
        public var video : [String]?
        public var videoDetails : VideoDetail?
        public var webUrl : String?
        public var isSelected:Bool = false
    
    private enum CodingKeys : String, CodingKey {

        case title

    }
}


