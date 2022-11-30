// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let dailyCheckIn = try DailyCheckIn(json)

import Foundation

// MARK: - DailyCheckIn
struct DailyCheckIn: Codable {
    var user: User_?
    var checkIns: [CheckIn]?

    enum CodingKeys: String, CodingKey {
        case user
        case checkIns = "check_ins"
    }
}

// MARK: DailyCheckIn convenience initializers and mutators

extension DailyCheckIn {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DailyCheckIn.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        user: User_?? = nil,
        checkIns: [CheckIn]?? = nil
    ) -> DailyCheckIn {
        return DailyCheckIn(
            user: user ?? self.user,
            checkIns: checkIns ?? self.checkIns
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CheckIn
struct CheckIn: Codable {
    var day: Int?
    var date: String?
    var checkedIn, today: Bool?

    enum CodingKeys: String, CodingKey {
        case day, date
        case checkedIn = "checked_in"
        case today
    }
}

// MARK: CheckIn convenience initializers and mutators

extension CheckIn {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CheckIn.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        day: Int?? = nil,
        date: String?? = nil,
        checkedIn: Bool?? = nil,
        today: Bool?? = nil
    ) -> CheckIn {
        return CheckIn(
            day: day ?? self.day,
            date: date ?? self.date,
            checkedIn: checkedIn ?? self.checkedIn,
            today: today ?? self.today
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - User
struct Users: Codable {
    var id: Int?
    var name: String?
    var profilePic: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePic = "profile_pic"
    }
}

// MARK: User convenience initializers and mutators

extension Users {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Users.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        name: String?? = nil,
        profilePic: String?? = nil
    ) -> Users {
        return Users(
            id: id ?? self.id,
            name: name ?? self.name,
            profilePic: profilePic ?? self.profilePic
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


//// MARK: - Rewards
//struct Rewards: Codable {
//    var status: Bool?
//    var data: [Any]?
//    var meta: Meta?
//    var link: Link?
//
//    enum CodingKeys: String, CodingKey {
//        case status, data
//        case meta
//        case link
//    }
//}
//
//// MARK: Rewards convenience initializers and mutators
//
//extension Rewards {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Rewards.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}



// MARK: - Rewards
struct Rewards: Codable {
    var status: Bool?
    var data: [RewardCode]?
    var meta: Meta?
    var link: Link?
}

// MARK: Rewards convenience initializers and mutators

extension Rewards {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Rewards.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        status: Bool?? = nil,
        data: [RewardCode]?? = nil,
        meta: Meta?? = nil,
        link: Link?? = nil
    ) -> Rewards {
        return Rewards(
            status: status ?? self.status,
            data: data ?? self.data,
            meta: meta ?? self.meta,
            link: link ?? self.link
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Datum
struct RewardCode: Codable {
    var id: Int?
    var displayName, promoCode: String?
    var validDate, createdAt: Int?
    var expired: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case promoCode = "promo_code"
        case validDate = "valid_date"
        case createdAt = "created_at"
        case expired
    }
}

// MARK: Datum convenience initializers and mutators

extension RewardCode {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RewardCode.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        displayName: String?? = nil,
        promoCode: String?? = nil,
        validDate: Int?? = nil,
        createdAt: Int?? = nil,
        expired: Bool?? = nil
    ) -> RewardCode {
        return RewardCode(
            id: id ?? self.id,
            displayName: displayName ?? self.displayName,
            promoCode: promoCode ?? self.promoCode,
            validDate: validDate ?? self.validDate,
            createdAt: createdAt ?? self.createdAt,
            expired: expired ?? self.expired
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}







