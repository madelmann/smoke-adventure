
// library imports

// project imports


/*
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
*/

public object Event
{
    public Vector<Condition> condition;
    public Vector<Effect> effects;
    public string id; // trigger
    public string room;
}
