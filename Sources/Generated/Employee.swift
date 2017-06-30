import SwiftyJSON

public struct Employee {
    public let id: String?
    public let firstName: String
    public let lastName: String
    public let email: String?

    public init(id: String?, firstName: String, lastName: String, email: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }

    public init(json: JSON) throws {
        // Required properties
        guard json["firstName"].exists() else {
            throw ModelError.requiredPropertyMissing(name: "firstName")
        }
        guard let firstName = json["firstName"].string else {
            throw ModelError.propertyTypeMismatch(name: "firstName", type: "string", value: json["firstName"].description, valueType: String(describing: json["firstName"].type))
        }
        self.firstName = firstName
        guard json["lastName"].exists() else {
            throw ModelError.requiredPropertyMissing(name: "lastName")
        }
        guard let lastName = json["lastName"].string else {
            throw ModelError.propertyTypeMismatch(name: "lastName", type: "string", value: json["lastName"].description, valueType: String(describing: json["lastName"].type))
        }
        self.lastName = lastName

        // Optional properties
        if json["id"].exists() &&
           json["id"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "id", type: "string", value: json["id"].description, valueType: String(describing: json["id"].type))
        }
        self.id = json["id"].string
        if json["email"].exists() &&
           json["email"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "email", type: "string", value: json["email"].description, valueType: String(describing: json["email"].type))
        }
        self.email = json["email"].string

        // Check for extraneous properties
        if let jsonProperties = json.dictionary?.keys {
            let properties: [String] = ["id", "firstName", "lastName", "email"]
            for jsonPropertyName in jsonProperties {
                if !properties.contains(where: { $0 == jsonPropertyName }) {
                    throw ModelError.extraneousProperty(name: jsonPropertyName)
                }
            }
        }
    }

    public func settingID(_ newId: String?) -> Employee {
      return Employee(id: newId, firstName: firstName, lastName: lastName, email: email)
    }

    public func updatingWith(json: JSON) throws -> Employee {
        if json["id"].exists() &&
           json["id"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "id", type: "string", value: json["id"].description, valueType: String(describing: json["id"].type))
        }
        let id = json["id"].string ?? self.id

        if json["firstName"].exists() &&
           json["firstName"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "firstName", type: "string", value: json["firstName"].description, valueType: String(describing: json["firstName"].type))
        }
        let firstName = json["firstName"].string ?? self.firstName

        if json["lastName"].exists() &&
           json["lastName"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "lastName", type: "string", value: json["lastName"].description, valueType: String(describing: json["lastName"].type))
        }
        let lastName = json["lastName"].string ?? self.lastName

        if json["email"].exists() &&
           json["email"].type != .string {
            throw ModelError.propertyTypeMismatch(name: "email", type: "string", value: json["email"].description, valueType: String(describing: json["email"].type))
        }
        let email = json["email"].string ?? self.email

        return Employee(id: id, firstName: firstName, lastName: lastName, email: email)
    }

    public func toJSON() -> JSON {
        var result = JSON([
            "firstName": JSON(firstName),
            "lastName": JSON(lastName),
        ])
        if let id = id {
            result["id"] = JSON(id)
        }
        if let email = email {
            result["email"] = JSON(email)
        }

        return result
    }
}
