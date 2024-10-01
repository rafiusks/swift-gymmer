import Foundation

struct Weight: Identifiable, Codable {
    var id: Int
    var weight: Float
    var date: Date
    var created_at: Date
    var user_id: UUID

    // Define the keys as they appear in your JSON response
    enum CodingKeys: String, CodingKey {
        case id
        case weight
        case date
        case created_at
        case user_id
    }

    // Custom Decoding to Handle Date Formats
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode id as Int
        id = try container.decode(Int.self, forKey: .id)
        
        // Decode weight as Float
        weight = try container.decode(Float.self, forKey: .weight)
        
        // Decode user_id as UUID
        user_id = try container.decode(UUID.self, forKey: .user_id)

        // Decode date (in "yyyy-MM-dd" format)
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = dateFormatter.date(from: dateString) {
            date = parsedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }

        // Decode created_at with support for fractional seconds
        let createdAtString = try container.decode(String.self, forKey: .created_at)
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let parsedCreatedAt = isoFormatter.date(from: createdAtString) {
            created_at = parsedCreatedAt
        } else {
            throw DecodingError.dataCorruptedError(forKey: .created_at, in: container, debugDescription: "Invalid created_at format")
        }
    }

    // Regular encoding (no need to customize unless needed)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(weight, forKey: .weight)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(date, forKey: .date)
        try container.encode(created_at, forKey: .created_at)
    }
}
