import Foundation
import UIKit

public class TixngoProfile {
    
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
    
    public init (firstName: String, lastName: String, gender: TixngoGender, face: String?, dateOfBirth: Date?, nationality: String?,
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

public class TixngoAddress {
    
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

public class TixngoPushNotification {
    
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

// Environments support by Tixngo
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

// All languages support by Tixngo
public enum TixngoLanguages: String {
    case en = "en"
    case ar = "ar"
    case de = "de"
    case ca = "ca"
    case es = "es"
    case fr = "fr"
    case no = "no"
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

public struct TixngoConfiguration {
    let sskLicenseKey: String?
    let isEnableDebug: Bool
    let defaultEnv: TixngoEnv
    let isEnableWallet: Bool?
    let isCheckAppStatus: Bool?
    let supportLanguages: [TixngoLanguages]
    let defaultLanguage: TixngoLanguages?
    let theme: TixngoTheme?
      
    public init(licenseKey: String? = nil,
                isEnableDebug: Bool = false,
                defaultEnv: TixngoEnv,
                isEnableWallet: Bool?,
                isCheckAppStatus: Bool?,
                supportLanguages: [TixngoLanguages] = [],
                defaultLanguage: TixngoLanguages?,
                theme: TixngoTheme?) {
        self.sskLicenseKey = licenseKey
        self.isEnableDebug = isEnableDebug
        self.defaultEnv = defaultEnv
        self.isEnableWallet = isEnableWallet
        self.isCheckAppStatus = isCheckAppStatus
        self.supportLanguages = supportLanguages
        self.defaultLanguage = defaultLanguage
        self.theme = theme
    }
    
    var json: [String: Any?] {
        return ["sskLicenseKey": sskLicenseKey ?? "",
                "isEnableDebug": isEnableDebug,
                "defaultEnv": defaultEnv.rawValue,
                "isEnableWallet": isEnableWallet ?? false,
                "isCheckAppStatus": isCheckAppStatus ?? false,
                "supportLanguages": supportLanguages.map({$0.rawValue}),
                "defaultLanguage": defaultLanguage?.rawValue,
                "theme": theme?.json
                ]
    }
    
    static var `default`: TixngoConfiguration {
        let theme = TixngoTheme(font: "Qatar2022",
                                colors: TixngoColor(primary: "0xff00a9b8", secondary: "0xff124254"))
        return TixngoConfiguration(licenseKey: "MEYCIQDO4RS/aRJmaKnRZOaq9FOYNehpX9s4FqTdiNf6flbkcAIhANK7ToiL/EANI1vCIRchcny5SHI8cYbzz3KiyfeZf6SX",
                                   isEnableDebug: true,
                                   defaultEnv: .int,
                                   isEnableWallet: false,
                                   isCheckAppStatus: false,
                                   defaultLanguage: .en,
                                   theme: theme)
    }
}

public struct TixngoTheme {
    let font: String
    let colors: TixngoColor
    
    public init(font: String, colors: TixngoColor) {
        self.font = font
        self.colors = colors
    }
    
    var json: [String: Any?] {
        return ["font": font,
                "colors": colors.json
                ]
    }
}

public struct TixngoColor {
    let primary: String?
    let secondary: String?
    let background: String?
    let barcode: String?
    let activationGreen: String?
    let activationBlue: String?
    let activationLightBlue: String?
    let activationYellow: String?
    let activationRed: String?
    let activationBlack: String?
    let greyBanner: String?
    let redBanner: String?
    let eventDetailPageBackground01: String?
    let deleteAccountPageBackground01: String?
    let pendingTransferItemBanner01: String?
    let transferHistoryItemBanner01: String?
    let transferHistoryItemBanner02: String?
    let deletedTicketItemBanner01: String?
    let tooltip: String?
    let eventDetailPageBanner01: String?
    let deleteAccountCompletedPageIcon01: String?
    let greenBanner: String?
    let ticketGeneralInfoIconColor: String?
    let recipientConfirmationPageBackground01: String?
    let transferCompletePageBackground01: String?
    let myGroupColor01: String?
    
    public init(primary: String? = nil,
                secondary: String? = nil,
                background: String? = nil,
                barcode: String? = nil,
                activationGreen: String? = nil,
                activationBlue: String? = nil,
                activationLightBlue: String? = nil,
                activationYellow: String? = nil,
                activationRed: String? = nil,
                activationBlack: String? = nil,
                greyBanner: String? = nil,
                redBanner: String? = nil,
                eventDetailPageBackground01: String? = nil,
                deleteAccountPageBackground01: String? = nil,
                pendingTransferItemBanner01: String? = nil,
                transferHistoryItemBanner01: String? = nil,
                transferHistoryItemBanner02: String? = nil,
                deletedTicketItemBanner01: String? = nil,
                tooltip: String? = nil,
                eventDetailPageBanner01: String? = nil,
                deleteAccountCompletedPageIcon01: String? = nil,
                greenBanner: String? = nil,
                ticketGeneralInfoIconColor: String? = nil,
                recipientConfirmationPageBackground01: String? = nil,
                transferCompletePageBackground01: String? = nil,
                myGroupColor01: String? = nil) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.barcode = barcode
        self.activationGreen = activationGreen
        self.activationBlue = activationBlue
        self.activationLightBlue = activationLightBlue
        self.activationYellow = activationYellow
        self.activationRed = activationRed
        self.activationBlack = activationBlack
        self.greyBanner = greyBanner
        self.redBanner = redBanner
        self.eventDetailPageBackground01 = eventDetailPageBackground01
        self.deleteAccountPageBackground01 = deleteAccountPageBackground01
        self.pendingTransferItemBanner01 = pendingTransferItemBanner01
        self.transferHistoryItemBanner01 = transferHistoryItemBanner01
        self.transferHistoryItemBanner02 = transferHistoryItemBanner02
        self.deletedTicketItemBanner01 = deletedTicketItemBanner01
        self.tooltip = tooltip
        self.eventDetailPageBanner01 = eventDetailPageBanner01
        self.deleteAccountCompletedPageIcon01 = deleteAccountCompletedPageIcon01
        self.greenBanner = greenBanner
        self.ticketGeneralInfoIconColor = ticketGeneralInfoIconColor
        self.recipientConfirmationPageBackground01 = recipientConfirmationPageBackground01
        self.transferCompletePageBackground01 = transferCompletePageBackground01
        self.myGroupColor01 = myGroupColor01
    }
    
    var json: [String: Any?] {
        return ["primary": primary,
                "secondary": secondary,
                "background": background,
                "barcode": barcode,
                "activationGreen": activationGreen,
                "activationBlue": activationBlue,
                "activationLightBlue": activationLightBlue,
                "activationYellow": activationYellow,
                "activationRed": activationRed,
                "activationBlack": activationBlack,
                "greyBanner": greyBanner,
                "redBanner": redBanner,
                "eventDetailPageBackground01": eventDetailPageBackground01,
                "deleteAccountPageBackground01": deleteAccountPageBackground01,
                "pendingTransferItemBanner01": pendingTransferItemBanner01,
                "transferHistoryItemBanner01": transferHistoryItemBanner01,
                "transferHistoryItemBanner02": transferHistoryItemBanner02,
                "deletedTicketItemBanner01": deletedTicketItemBanner01,
                "tooltip": tooltip,
                "eventDetailPageBanner01": eventDetailPageBanner01,
                "deleteAccountCompletedPageIcon01": deleteAccountCompletedPageIcon01,
                "greenBanner": greenBanner,
                "ticketGeneralInfoIconColor": ticketGeneralInfoIconColor,
                "recipientConfirmationPageBackground01": recipientConfirmationPageBackground01,
                "transferCompletePageBackground01": transferCompletePageBackground01,
                "myGroupColor01": myGroupColor01,
                ]
    }
}
