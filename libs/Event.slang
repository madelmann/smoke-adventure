
// library imports

// project imports


/*
"id": "enter_room",
"item": "music_box",
"room": "station",
"repeat": true,
"effect": {
    "text": "A train whistles in the distance.",
    "flag": [],
    "unflag": []
},
"require": {
    "flag": [],
    "item": []
}
*/

public object Event
{
    public Vector<string> effectFlag;
    public string effectText;
    public Vector<string> effectUnflag;
    public string id; // trigger
    public string item;
    public bool repeat;
    public Vector<string> requireFlag;
    public Vector<string> requireItem;
    public string room;
    public bool triggered;

    public void Constructor() {
        effectFlag   = new Vector<string>();
        effectUnflag = new Vector<string>();
        requireFlag  = new Vector<string>();
        requireItem  = new Vector<string>();
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }
}
