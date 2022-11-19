//
//  ErrorMessages.swift
//  GHFollowers
//
//  Created by Danilo on 01/11/22.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "Invalid username, please try again."
    case unableToComplete = "Internet connection error, please try again."
    case invalidResponse = "Server error, please try again."
    case invalidData = "Invalid data, please try again."
    case unableToFavorite = "There wase an error favoriting this user. Please try again"
    case alreadyExist = "the use alreadi exist in favorite list."
}
