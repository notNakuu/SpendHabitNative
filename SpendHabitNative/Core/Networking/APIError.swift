//
//  APIError.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation

enum APIError: Error{
    case invalidURL
    case requestFailed
    case unexpectedStatusCode(Int)
    case decodingFailed(Error)
}
