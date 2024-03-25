//
//  ResourceReader.swift
//  Currency ConverterTests
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation


class ResourceReader {
    func decode<T>(_ resourceType: T.Type, from resource: String) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: resource, withExtension: "json")!

        do {
            let data = try Data(contentsOf: url)
            let object = try decoder.decode(resourceType, from: data)
            return object
        } catch {
            guard error is DecodingError else {
                return nil
            }
            
        }
        return nil
    }
}
