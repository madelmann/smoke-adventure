
// library imports
import FileReader;
import System.Collections.Vector;

// project imports
import Item;
import Player;
import Room;
import Utils;


public object World
{
    public Vector<Item> items;
    //public Vector<NPC> npcs;
    public Player player;
    public Vector<Room> rooms;

    public void Constructor() {
        loadItems();
        loadPlayer();
        loadRooms();
    }

    private void loadItems() modify {
        var data = JsonArray loadFile( "data/items.json" );

        items = new Vector<Item>();

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

    private void loadPlayer() modify {
        var data = JsonObject loadFile( "data/player.json" );

        player = new Player() {
            {   //player.flags
                foreach ( JsonValue flag : JsonArray data[ "flags" ] ) {
                    player.flags.push_back( flag.asString() );
                }
            }
            {   //player.inventory
                foreach ( JsonValue item : JsonArray data[ "inventory" ] ) {
                    player.inventory.push_back( item.asString() );
                }
            }
            player.location = data[ "location" ].asString();
        }
    }

    private void loadRooms() modify {
        var data = loadFile( "data/rooms.json" );

        rooms = new Vector<Room>();

        foreach ( JsonObject r : JsonObject data ) {
            var room = new Room() {
                room.description = r[ "description" ].asString();
                room.id          = r[ "id" ].asString();
                room.name        = r[ "name" ].asString();

                {   // room.exits
                    var exits const = JsonObject r[ "exits" ];

                    if ( exits.isMember( "east" ) )  room.exits.insert( "east",  exits[ "east" ].asString() );
                    if ( exits.isMember( "north" ) ) room.exits.insert( "north", exits[ "north" ].asString() );
                    if ( exits.isMember( "south" ) ) room.exits.insert( "south", exits[ "south" ].asString() );
                    if ( exits.isMember( "west" ) )  room.exits.insert( "west",  exits[ "west" ].asString() );

                    // foreach ( Pair<string, string> p : room.exits ) {
                    //     print( room.name + ": " + cast<string>( p ) );
                    // }
                }
                {   // items
                    foreach ( JsonValue item : JsonArray r[ "items" ] ) {
                        room.items.push_back( item.asString() );

                        // print( room.name + ": " + item.asString() + " [item]" );
                    }
                }
                {   // npcs
                    foreach ( JsonValue npc : JsonArray r[ "npcs" ] ) {
                        room.npcs.push_back( npc.asString() );

                        // print( room.name + ": " + npc.asString() + " [npc]" );
                    }
                }
            }

            rooms.push_back( room );
        }
    }
}
