
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

    public static Event parse( JsonValue data ) {
        var event = new Event() {
            var e = JsonObject data;

            event.id     = e[ "id" ].asString();
            event.repeat = e[ "repeat" ].asBool();

            if ( e.isMember( "effect" ) ) {
                var effect const = JsonObject e[ "effect" ];
                event.effectText = effect[ "text" ].asString();

                foreach ( JsonValue f : JsonArray effect[ "flag" ] ) {
                    event.effectFlag.push_back( f.asString() );
                }
                foreach ( JsonValue i : JsonArray effect[ "unflag" ] ) {
                    event.effectUnflag.push_back( i.asString() );
                }
            }
            if ( e.isMember( "item" ) ) event.item = e[ "item" ].asString();
            if ( e.isMember( "require" ) ) {
                var require const = JsonObject e[ "require" ];

                foreach ( JsonValue f : JsonArray require[ "flag" ] ) {
                    event.requireFlag.push_back( f.asString() );
                }
                foreach ( JsonValue i : JsonArray require[ "item" ] ) {
                    event.requireItem.push_back( i.asString() );
                }
            }
            if ( e.isMember( "room" ) )      event.room = e[ "room" ].asString();
            if ( e.isMember( "triggered" ) ) event.item = e[ "triggered" ].asBool();
        }

        return event;
    }

    public void Constructor() {
        effectFlag   = new Vector<string>();
        effectUnflag = new Vector<string>();
        requireFlag  = new Vector<string>();
        requireItem  = new Vector<string>();
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }

    public string =operator( string ) const {
        return id + " | " + room + " | " + item + " | " + triggered;
    }
}
