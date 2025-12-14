//
//  Endpoint.swift
//  SpendHabitNative
//
//  Created by Angel Mariano Mishchanchuk on 6/12/25.
//

import Foundation

struct Endpoint{
    let path: String
    let queryItems: [URLQueryItem]?
    let method: RequestMethod
    let body: Encodable?
    let headers: [String: String]?
}
