//
//  File.swift
//  Reported
//
//  Created by Sampson Liao on 4/27/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit

final class FormObj: Codable {
    var issueCategory: String
    var dirOfTravel: String
    var transMode: String
    var nearestCrossStreet: String
    var dateTime: String
    var latitude: String
    var longitude: String
    var descripText: String
    var name: String
    var email: String
    var phone: String
    var followUp: Bool
    
    init(issueCategory: String!, dirOfTravel: String!, transMode: String!, nearestCrossStreet: String!, dateTime: String!, latitude: String!, longitude: String!, descripText: String!, name: String!, email: String!, phone: String!, followUp: Bool!) {
        self.issueCategory = issueCategory
        self.dirOfTravel = dirOfTravel
        self.transMode = transMode
        self.nearestCrossStreet = nearestCrossStreet
        self.dateTime = dateTime
        self.latitude = latitude
        self.longitude = longitude
        self.descripText = descripText
        self.name = name
        self.email = email
        self.phone = phone
        self.followUp = followUp
    }
}

