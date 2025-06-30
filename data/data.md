1. Rooms (Locations)

Each room contains:

    description: Text description
    items: List of object IDs present
    npcs: List of character IDs present
    exits: Dict of directions to room names (e.g. "north": "alley")

Fields:

{
  "name": "blue_note",
  "description": "...",
  "items": ["cufflink"],
  "npcs": ["vivienne"],
  "exits": {
    "east": "alley",
    "south": "station"
  }
}


2. Items

Each item contains:

    name: Display name
    description: On examine
    usable: Boolean Whether the player can "use" it
    locked: Boolean Whether the object is locked (e.g. lockers, doors)
    requires_item: String	The item required to unlock/interact (e.g. a key)
    contains: String What’s inside if unlocked or opened
    use_effect: String	Identifier for the effect it triggers (custom logic handler) (e.g. "reveal_key")
    Optional flags: hidden, combine_with, locked, etc.

Fields:

{
  "id": "music_box",
  "name": "music box",
  "description": "...",
  "usable": true,
  "use_effect": "reveal_key"
}


3. NPCs (Characters)

Each NPC contains:

    name: Display name
    dialogue_tree: Map of dialogue node IDs to lines + choices
    Optional: conditions (flags required), item interactions, branching logic

Fields:

{
  "id": "vivienne",
  "name": "Vivienne Sinclair",
  "dialogue": {
    "intro": {
      "text": "...",
      "choices": [
        { "text": "...", "next": "more_info", "requires_flag": "found_cufflink" }
      ]
    },
    "give_key": {
      "text": "Here's the key...",
      "set_flag": "has_locker_key"
    }
  }
}


4. Flags (Player State)

Track progression, choices, puzzle states.

Fields:

{
  "found_cufflink": true,
  "has_locker_key": true,
  "gave_ledger": false
}


5. Player

Tracks the player’s current situation:

    location: Current room
    inventory: List of item IDs
    flags: Game progression flags

Fields:

{
  "location": "blue_note",
  "inventory": ["music_box", "locker_key"],
  "flags": {
    "found_cufflink": true
  }
}


6. Scripted Events

Events can be attached to:

    Item use
    Entering a room
    A specific player state

{
  "trigger": "enter_room",
  "room": "throne_room",
  "conditions": {
    "flags": {
      "door_unlocked": true
    }
  },
  "effect": {
    "text": "The king greets you warmly.",
    "set_flag": "talked_to_king"
  }
}
