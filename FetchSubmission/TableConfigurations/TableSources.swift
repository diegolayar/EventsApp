// List of events that where liked

var favoriteEvents: [EventInfo] = []

// A Set to have faster access to check if an event is liked, instead of O(n) for Array.contains

var favoriteEventsSet: Set<Int> = []

// Array of favorited events that acts asa middleman with CoreData and favorite events

var savedEvents: [SavedEvent] = []

