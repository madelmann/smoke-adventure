
// library imports
import FileReader;
import System.Collections.Vector;

// project imports
import Item;
import NPC;
import Player;
import Room;
import Utils;


public object World
{
    public string intro;
    public Vector<Item> items;
    public Vector<NPC> npcs;
    public Player player;
    public Vector<Room> rooms;

    public void Constructor() {
        items  = new Vector<Item>();
        npcs   = new Vector<NPC>();
        player = new Player();
        rooms  = new Vector<Room>();

        load();
    }

    public void Destructor() {
        //save();   // auto save on exit
    }

    public void load() modify {
        loadIntro();
        loadItems();
        loadNPCs();
        loadPlayer();
        loadRooms();
    }

    public void save() const {
        saveItems();
        saveNPCs();
        savePlayer();
        saveRooms();
    }

    private void loadIntro() modify {
        intro = loadFile( "data/intro.txt" );
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
                    var iarr const = JsonArray i[ "contains" ];
                    foreach ( JsonValue s : iarr ) {
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

        // TODO: implement NPC loading
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
            var itemData = new JsonObject() {
                itemData.addMember( "id", i.id );
                itemData.addMember( "name", i.name );
                itemData.addMember( "description", i.description );
                itemData.addMember( "usable", i.usable );
                itemData.addMember( "locked", i.locked );
                itemData.addMember( "requires_item", i.requiresItem );

                var containsData = new JsonArray();
                foreach ( string s : i.contains ) {
                    containsData.addMember( new JsonValue( s ) );
                }
                itemData.addMember( "contains", containsData );
            }

            data.addMember( itemData );
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
