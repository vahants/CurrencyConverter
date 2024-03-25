//
//  ApplicationError+ServerError.swift
//  Currency Converter
//
//  Created by Vahan Tsogolakyan on 23.03.24.
//

import Foundation

protocol ErrorType {
    /// Error title
    var title: String { get }
    /// Error description
    var description: String { get }
    /// Error domain
    var errorDomain: String { get }
    /// Cocoa error
    var cocoaError: NSError { get }
}

enum ApplicationError {}

/// Generic server error
extension ApplicationError {

    /// Server errors
    enum Network {

        static let networkErrorDomain = "freecurrencyapi.ServerError.ErrorCode"

        /// General errors
        enum General: Int, Error, ErrorType {
            /// Server error
            case badRequest = 400
            case notAuthorised = 401
            case notAllowed = 403
            case nonExist = 404
            case validationError = 422
            case serverError = 500
            /// All the other not handled error cases
            case unknown = -101

            /// Response encoding error
            case encodingFailure = -102

            /// Error title
            var title: String {
                return "Error"
            }

            /// Error description i.e. message
            var description: String {
                switch self {
                case .badRequest:
                    return "Bad Request"
                case .notAuthorised:
                    return "Invalid authentication credentials"
                case .notAllowed:
                    return "You are not allowed to use this endpoint, please upgrade your plan"
                case .nonExist:
                    return "A requested endpoint does not exist"
                case .validationError:
                    return "Validation error, please check the list of validation errors:"
                case .serverError:
                    return "Internal Server Error - let us know: support@freecurrencyapi.com"
                case .unknown:
                    return "An unknown error has occurred. Please try again later."
                case .encodingFailure:
                    return "There was a problem with the Encoding file. Please try again later."
                }
            }

            /// Error domain
            var errorDomain: String {
                return networkErrorDomain
            }

            /// Cocoa error instance
            var cocoaError: NSError {
                return NSError(domain: errorDomain, code: rawValue, userInfo: [NSLocalizedDescriptionKey: description])
            }
        }
    }
}
