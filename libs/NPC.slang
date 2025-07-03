
// library imports
import libJson.Object;

// project imports


/*
"id": "mick",
"name": "Mick",
"description": "A gruff, loyal locker attendant with a gruff personality.",
"personality": "Gruff, loyal, slow to trust.",
"dialogue": {
    "intro": {
        "text": "You ain't supposed to be back here.",
        "choices": [
            { "text": "Vivienne sent me.", "next": "trust" },
            { "text": "I need access to locker 314.", "next": "locker" }
        ]
    },
    "trust": {
        "requires_flag": "sent_to_mick",
        "text": "...Alright. If Viv vouched, maybe you're okay.",
        "set_flag": "mick_trusts_you"
    },
    "locker": {
        "requires_flag": "mick_trusts_you",
        "text": "Here, take the key. I never saw you.",
        "set_flag": "has_locker_key",
        "give_item": "locker_key"
    }
}
*/

public object NPC
{
    public string description;
    public JsonObject dialogue;
    public string id;
    public string name;
    public string personality;

    public void Constructor() {
        dialogue = new JsonObject();
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }
}
