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
}
