
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
    public Vector<string> flag;
    public string id; // trigger
    public string item;
    public bool repeat;
    public Vector<string> requireFlag;
    public Vector<string> requireItem;
    public string room;
    public string text;
    public bool triggered;
    public Vector<string> unflag;

    public void Constructor() {
        flag        = new Vector<string>();
        requireFlag = new Vector<string>();
        requireItem = new Vector<string>();
        unflag      = new Vector<string>();
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }
}
