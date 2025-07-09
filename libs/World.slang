
// library imports
import FileReader;
//import libSQLite3;
//import libSQLite3.Exceptions;
import System.Collections.Vector;

// project imports
import Event;
import Item;
import NPC;
import Player;
import Room;
import Utils;


public object World
{
    public Vector<Event> events;
    public string intro;
    public Vector<Item> items;
    public Vector<NPC> npcs;
    public Player player;
    public Vector<Room> rooms;

    public void Constructor() {
        events = new Vector<Event>();
        items  = new Vector<Item>();
        npcs   = new Vector<NPC>();
        player = new Player();
        rooms  = new Vector<Room>();

        load();
    }

    public void Destructor() {
        //save();   // auto save on exit
    }

    Event getEvent( string id, string item, string room ) const {
        foreach ( Event e : events ) {
            if ( e.id == id && e.item == item && e.room == room ) {
                // print( "Event '" + id + "', '" + item + "', '" + room + "' triggered." );
                return e;
            }
        }

        // print( "Event '" + id + "', '" + item + "', '" + room + "' not found!" );
        return Event null;
    }

    Item getItem( string id ) const throws {
        foreach ( Item i : items ) {
            if ( i.id == id ) {
                return i;
            }
        }

        throw "Item with id " + id + " not found!";
    }

    NPC getNPC( string id ) const throws {
        foreach ( NPC n : npcs ) {
            if ( n.id == id ) {
                return n;
            }
        }

        throw "NPC with id " + id + " not found!";
    }

    Room getRoom( string id ) const throws {
        foreach ( Room r : rooms ) {
            if ( r.id == id ) {
                return r;
            }
        }

        throw "Room with id " + id + " not found!";
    }

    public void load() modify {
        loadEvents();
        loadIntro();
        loadItems();
        loadNPCs();
        loadPlayer();
        loadRooms();

        /*
        var db = new Sqlite3Database( "data.db" );
        var result = db.exec( "SELECT name, type FROM sqlite_master" );

        try {
            print( "ErrorCode: " + db.errCode() );
            print( "ErrroMessage: " + db.errMsg() );
            print( "Results(" + result.Rows.size() + ") = " + cast<string>( result ) );
        }
        */
    }

    public void save() const {
        saveEvents();
        saveItems();
        saveNPCs();
        savePlayer();
        saveRooms();
    }

    private void loadIntro() modify {
        intro = loadFile( "data/intro.txt" );
    }

    private void loadEvents() modify {
        var data = JsonArray loadJson( "data/events.json" );

        events.clear();

        /*
        "id": "enter_room",
        "room": "throne_room",
        "repeat": true,
        "effect": {
            "text": "The king greets you warmly.",
            "set_flag": ["talked_to_king"],
            "unset_flag": ["not_talked_to_king"]
        },
        "require": {
            "flag": ["door_unlocked"],
            "item": []
        }
        */
        foreach ( JsonObject e : data ) {
            var event = new Event() {
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
            events.push_back( event );
        }
    }

    private void loadItems() modify {
        var data = JsonArray loadJson( "data/items.json" );

        items.clear();

        foreach ( JsonObject i : data ) {
            var item = new Item() {
                item.description  = i[ "description" ].asString();
                item.id           = i[ "id" ].asString();
                item.name         = i[ "name" ].asString();
                item.usable       = i[ "usable" ].asBool();

                if ( i.isMember( "contains" ) ) {
                    foreach ( JsonValue s : JsonArray i[ "contains" ] ) {
                        item.contains.push_back( s.asString() );
                    }
                }
                if ( i.isMember( "locked" ) )        item.locked       = i[ "locked" ].asBool();
                if ( i.isMember( "requires_item" ) ) item.requiresItem = i[ "requires_item" ].asString();
                if ( i.isMember( "use_effect" ) )    item.useEffect    = i[ "use_effect" ].asBool();
            }
            items.push_back( item );
        }
    }

    private void loadNPCs() modify {
        var data = JsonArray loadJson( "data/npcs.json" );

        npcs.clear();

        foreach ( JsonValue n : data ) {
            npcs.push_back( NPC.parse( n ) );
        }
    }

    private void loadPlayer() modify {
        var data = JsonObject loadJson( "data/player.json" );

        {   //player.flags
            player.flags.clear();
            foreach ( JsonValue flag : JsonArray data[ "flags" ] ) {
                player.flags.push_back( flag.asString() );
            }
        }
        {   //player.inventory
            player.inventory.clear();
            foreach ( JsonValue item : JsonArray data[ "inventory" ] ) {
                player.inventory.push_back( item.asString() );
            }
        }
        player.location = data[ "location" ].asString();
    }

    private void loadRooms() modify {
        var data = loadJson( "data/rooms.json" );

        rooms.clear();

        foreach ( JsonObject r : JsonObject data ) {
            var room = new Room() {
                room.description = r[ "description" ].asString();
                room.id          = r[ "id" ].asString();
                room.name        = r[ "name" ].asString();

                if ( r.isMember( "exits" ) ) {
                    var exits const = JsonObject r[ "exits" ];

                    if ( exits.isMember( "east" ) )  room.exits.insert( "east",  exits[ "east" ].asString() );
                    if ( exits.isMember( "north" ) ) room.exits.insert( "north", exits[ "north" ].asString() );
                    if ( exits.isMember( "south" ) ) room.exits.insert( "south", exits[ "south" ].asString() );
                    if ( exits.isMember( "west" ) )  room.exits.insert( "west",  exits[ "west" ].asString() );

                    // foreach ( Pair<string, string> p : room.exits ) {
                    //     print( room.name + ": " + cast<string>( p ) );
                    // }
                }
                if ( r.isMember( "items" ) ) {   // items
                    foreach ( JsonValue item : JsonArray r[ "items" ] ) {
                        room.items.push_back( item.asString() );

                        // print( room.name + ": " + item.asString() + " [item]" );
                    }
                }
                if ( r.isMember( "npcs" ) ) {   // npcs
                    foreach ( JsonValue npc : JsonArray r[ "npcs" ] ) {
                        room.npcs.push_back( npc.asString() );

                        // print( room.name + ": " + npc.asString() + " [npc]" );
                    }
                }
            }

            rooms.push_back( room );
        }
    }

    private void saveEvents() {
        /*
        "id": "enter_room",
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

        var data = new JsonArray();

        foreach ( Event e : events ) {
            var event = new JsonObject() {
                event.addMember( "id", e.id );
                event.addMember( "repeat", e.repeat );
                event.addMember( "room", e.room );
                event.addMember( "triggered", e.triggered );

                var effect = new JsonObject() {
                    effect.addMember( "text", e.effectText );

                    var flagArr = new JsonArray();
                    foreach ( string token : e.effectFlag ) {
                        flagArr.addMember( new JsonValue( token ) );
                    }
                    effect.addMember( "flag", flagArr );

                    var unflagArr = new JsonArray();
                    foreach ( string token : e.effectUnflag ) {
                        unflagArr.addMember( new JsonValue( token ) );
                    }
                    effect.addMember( "unflag", unflagArr );
                }
                event.addMember( "effect", effect );

                var require = new JsonObject() {
                    var flagArr = new JsonArray();
                    foreach ( string token : e.requireFlag ) {
                        flagArr.addMember( new JsonValue( token ) );
                    }
                    require.addMember( "flag", flagArr );

                    var itemArr = new JsonArray();
                    foreach ( string token : e.requireItem ) {
                        itemArr.addMember( new JsonValue( token ) );
                    }
                    require.addMember( "item", itemArr );
                }
                event.addMember( "require", require );
            }

            data.addMember( event );
        }

        var writer = new JsonStyledWriter();
        storeFile( "save/data/events.json", writer.toString( data ) );
    }

    private void saveItems() {
        /*
        "id": "locker",
        "name": "locker",
        "description": "A locked metal locker, paint flaking. There's a faint ticking from within.",
        "usable": false,
        "locked": true,
        "requires_item": "locker_key",
        "contains": ["ledger"]
        */

        var data = new JsonArray();

        foreach ( Item i : items ) {
            var item = new JsonObject() {
                item.addMember( "id", i.id );
                item.addMember( "name", i.name );
                item.addMember( "description", i.description );
                item.addMember( "usable", i.usable );
                item.addMember( "locked", i.locked );
                item.addMember( "requires_item", i.requiresItem );

                var containsData = new JsonArray();
                foreach ( string s : i.contains ) {
                    containsData.addMember( new JsonValue( s ) );
                }
                item.addMember( "contains", containsData );
            }

            data.addMember( item );
        }

        var writer = new JsonStyledWriter();
        storeFile( "save/data/items.json", writer.toString( data ) );
    }

    private void saveNPCs() {
        /*
        "vivienne": {
            "name": "Vivienne Sinclair",
            "description": "A jazz singer with a mysterious past.",
            "personality": "Wary but charming. She hides fear behind wit.",
            "intro": {
                "text": "You again. I told you I don't know anything about Lorne.",
                "choices": [
                    { "text": "I found this cufflink at your club.", "next": "cufflink" },
                    { "text": "Come on, Viv. Talk to me.", "next": "soften" }
                ]
            },
            "soften": {
                "text": "Don't make me regret this. He was in trouble. Real trouble.",
                "choices": [{ "text": "What kind of trouble?", "next": "trouble" }]
            },
            "cufflink": {
                "condition": "found_cufflink",
                "text": "...Lorne always wore those. I told him not to come back here.",
                "choices": [{ "text": "Why?", "next": "warning" }]
            },
            "warning": {
                "text": "Because Leone was watching. And Lorne wasn’t careful.",
                "set_flag": "vivienne_warned_you"
            },
            "trouble": {
                "text": "He talked about a shipment, something he needed to hide. Maybe Mick knows more.",
                "set_flag": "sent_to_mick"
            }
        }
        */

        // var data = new JsonArray();

        // var writer = new JsonStyledWriter();
        // storeFile( "save/data/npcs.json", writer.toString( data ) );
    }

    private void savePlayer() const {
        /*
        "location": "detective_office",
        "inventory": ["detective hat", "music_box", "locker_key"],
        "flags": ["found_cufflink"]
        */

        var flags = new JsonArray();
        foreach ( string flag : player.flags ) {
            flags.addMember( new JsonValue( flag ) );
        }

        var inventory = new JsonArray();
        foreach ( string item : player.inventory ) {
            inventory.addMember( new JsonValue( item ) );
        }

        var data = new JsonObject();
        data.addMember( "location", player.location );
        data.addMember( "flags", flags );
        data.addMember( "inventory", inventory );

        var writer = new JsonStyledWriter();
        storeFile( "save/data/player.json", writer.toString( data ) );
    }

    private void saveRooms() const {
        /*
        "id": "blue_note",
        "name": "The Blue Note",
        "description": "Dim lighting. A haze of smoke hangs in the air as a saxophone moans through the static of an old speaker. Red curtains hang heavy behind the stage.",
        "items": ["cufflink", "music_box"],
        "npcs": ["vivienne"],
        "exits": {
            "east": "alley",
            "south": "station"
            }
        }
        */

        var data = new JsonArray();

        foreach ( Room r : rooms ) {
            var roomData = new JsonObject() {
                roomData.addMember( "id", r.id );
                roomData.addMember( "name", r.name );
                roomData.addMember( "description", r.description );

                var exits = new JsonObject();
                foreach ( Pair<string, string> e : r.exits ) {
                    exits.addMember( e.first, e.second );
                }
                roomData.addMember( "exits", exits );

                var itemData = new JsonArray();
                foreach ( string i : r.items ) {
                    itemData.addMember( new JsonValue( i ) );
                }
                roomData.addMember( "items", itemData );

                var npcData = new JsonArray();
                foreach ( string n : r.npcs ) {
                    npcData.addMember( new JsonValue( n ) );
                }
                roomData.addMember( "npcs", npcData );
            }

            data.addMember( roomData );
        }

        var writer = new JsonStyledWriter();
        storeFile( "save/data/rooms.json", writer.toString( data ) );
    }
}
