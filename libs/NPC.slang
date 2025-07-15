
// library imports
import libJson.Object;
import System.Collections.Map;

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

public object Choice
{
    public string next;
    public string requireFlag;
    public string requireItem;
    public string text;

    public static Choice parse( JsonValue data ) {
        var choice = new Choice() {
            var c = JsonObject data;

            choice.next = c[ "next" ].asString();
            choice.text = c[ "text" ].asString();
            if ( c.isMember( "require_flag" ) ) choice.requireFlag = c[ "require_flag" ].asString();
            if ( c.isMember( "require_item" ) ) choice.requireItem = c[ "require_item" ].asString();
        }

        return choice;
    }

    public string =operator( string ) const {
        return text + " | " + next;
    }
}

public object Dialogue
{
    public Map<int, Choice> choices;     // text, nextDialogue
    public string setFlag;
    public string setItem;
    public string text;

    public static Dialogue parse( JsonValue data ) modify {
        var dialogue = new Dialogue() {
            var d = JsonObject data;

            dialogue.text = d[ "text" ].asString();

            if ( d.isMember( "choices" ) ) {
                foreach ( JsonValue c : JsonArray d[ "choices" ] ) {
                    dialogue.choices.insert( dialogue.choices.size(), Choice.parse( c ) );
                }
            }
            if ( d.isMember( "set_flag" ) ) dialogue.setFlag = d[ "set_flag" ].asString();
            if ( d.isMember( "set_item" ) ) dialogue.setItem = d[ "set_item" ].asString();
        }

        return dialogue;
    }

    public void Constructor() {
        choices = new Map<int, Choice>();
    }

    public string =operator( string ) const {
        return text + " | " + setFlag + " | " + setItem;
    }
}

public object NPC
{
    public string description;
    public Map<string, Dialogue> dialogue;
    public string id;
    public string name;
    public string personality;

    public static NPC parse( JsonValue data ) modify {
        var npc = new NPC() {
            var d = JsonObject data;

            npc.description  = d[ "description" ].asString();
            npc.id           = d[ "id" ].asString();
            npc.name         = d[ "name" ].asString();
            npc.personality  = d[ "personality" ].asString();

            foreach ( Pair<string, JsonValue> p : JsonObject d[ "dialogue" ] ) {
                npc.dialogue.insert( p.first, Dialogue.parse( p.second ) );
            }
        }

        return npc;
    }

    public void Constructor() {
        dialogue = new Map<string, Dialogue>();
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }

    public string =operator( string ) const {
        return id + " | " + name + " | " + description;
    }
}
