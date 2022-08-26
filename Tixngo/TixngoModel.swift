import Foundation
import UIKit

class TixngoProfile {
    
    private let firstName: String
    private let lastName: String
    private let gender: TixngoGender
    private let face: String?
    private let dateOfBirth: Date?
    private let nationality: String?
    private let passportNumber: String?
    private let idCardNumber: String?
    private let email: String?
    private let phoneNumber: String?
    private let address: TixngoAddress?
    private let birthCity: String?
    private let birthCountry: String?
    private let residenceCountry: String?
    
    init (firstName: String, lastName: String, gender: TixngoGender, face: String?, dateOfBirth: Date?, nationality: String?,
          passportNumber: String?, idCardNumber: String?, email: String?, phoneNumber: String?, address: TixngoAddress?,
          birthCity: String?, birthCountry: String?, residenceCountry: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.face = face
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.passportNumber = passportNumber
        self.idCardNumber = idCardNumber
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.birthCity = birthCity
        self.birthCountry = birthCountry
        self.residenceCountry = residenceCountry
    }
    
    func toJson() -> [String: Any] {
        var result: [String: Any] = [
            "firstName" : firstName,
            "lastName": lastName,
            "gender": gender.rawValue
        ]
        if let face = face {
            result["face"] = face
        }
        if let dateOfBirth = dateOfBirth {
            result["dateOfBirth"] = dateOfBirth.toDobString()
        }
        if let nationality = nationality {
            result["nationality"] = nationality
        }
        if let passportNumber = passportNumber {
            result["passportNumber"] = passportNumber
        }
        if let idCardNumber = idCardNumber {
            result["idCardNumber"] = idCardNumber
        }
        if let email = email {
            result["email"] = email
        }
        if let phoneNumber = phoneNumber {
            result["phoneNumber"] = phoneNumber
        }
        if let address = address {
            result["address"] = address.toJson()
        }
        if let birthCity = birthCity {
            result["birthCity"] = birthCity
        }
        if let birthCountry = birthCountry {
            result["birthCountry"] = birthCountry
        }
        if let residenceCountry = residenceCountry {
            result["residenceCountry"] = residenceCountry
        }
        return result
    }
    
}

class TixngoAddress {
    
    private let line1: String
    private let line2: String?
    private let line3: String?
    private let city: String
    private let zip: String
    private let countryCode: String
    
    
    init (line1: String, line2: String?, line3: String?, city: String, zip: String, countryCode: String) {
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.city = city
        self.zip = zip
        self.countryCode = countryCode
    }
    
    func toJson() -> [String: Any] {
        var result = [
            "line1" : line1,
            "city": city,
            "zip": zip,
            "countryCode": countryCode,
        ]
        if let line2 = line2 {
            result["line2"] = line2
        }
        if let line3 = line3 {
            result["line3"] = line3
        }
        return result
    }
    
}

class TixngoPushNotification {
    
    private let data: [String: Any]?
    private let notification: [String: Any]?
    
    
    init? (_ userInfo: [String: Any?]) {
        var data = [String: Any]()
        var notification = [String: Any]()
        
        var messageId: String?
        for (key, value) in userInfo {
            if key == "gcm.message_id" || key == "google.message_id" || key == "message_id" {
                messageId = value as? String
                continue
            }
            if key == "aps" {
                let aps = value as! [String: Any]
                if let title = aps["alert"] as? String {
                    notification["title"] = title
                }
                if let alert = aps["alert"] as? [String: Any] {
                    notification["body"] = alert["body"]
                    notification["title"] = alert["title"]
                }
                continue
            }
            if !(key == "fcm_options" || key == "to" || key == "from" || key == "collapse_key" || key == "message_type" || key.hasPrefix("google.") || key.hasPrefix("gcm.")) {
                data[key] = value
            }
        }
        if messageId != nil {
            self.data = data
            self.notification = notification
        } else {
            return nil
        }
    }
    
    func toJson() -> [String: Any] {
        var result = [String: Any]()
        if let data = data {
            result["data"] = data
        }
        if let notification = notification {
            result["notification"] = notification
        }
        return result
    }
    
}

public enum TixngoEnv: String {
    case demo       = "DEMO"
    case int        = "INT"
    case val        = "VAL"
    case preprod    = "PREPROD"
    case prod       = "PROD"
}

public enum TixngoGender: String {
    case male       = "male"
    case female     = "female"
    case other      = "other"
    case unknown    = "unknown"
}

fileprivate extension Date {
    func toDobString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
