//
//  LocalResources.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

protocol LocalResources {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
    func loadJSONToData(filename: String) -> Data
}

extension LocalResources {

    var bundle: Bundle {
        return Bundle.main
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }

    func loadJSONToData(filename: String) -> Data {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }
        do {
            let data = try String(contentsOf: path)
            return data.data(using: .utf8)!
        } catch {
            fatalError("Failed to loaded JSON")
        }
    }

}
