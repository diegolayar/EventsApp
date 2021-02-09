// I had to make many structs because the API formats events JSON's in an odd way

struct ResultIndividual: Decodable { let performers: [Performer] }
struct Performer: Decodable { let image: String }
struct Result: Decodable { let events: [Event] }
struct Event: Decodable { let id: Int }
