
// library imports
import FileReader;
import libJson;
import System.Collections.Vector;

// project imports
import Player;
import Room;


public object World
{
    public Room currentRoom;
    //public Vector<NPC> npcs;
    public Player player;
    public Vector<Room> rooms;

    public void Constructor() {
        load();
    }

    public void give( string item, string to ) modify {
        if ( !player.inventory.contains( item ) ) {
            print( "You don't have a " + item );
            return;
        }

        foreach ( string n : currentRoom.npcs ) {
            if ( n == to ) {
                print( "You are giving " + item + " to " + n );

                player.inventory.erase( player.inventory.indexOf( item ) );

                // TODO: implement give action
                return;
            }
        }
    }

    public void go( string direction ) modify {
        foreach ( Pair<string, string> p : currentRoom.exits ) {
            //print( currentRoom.name + ": " + p.first + " => " + p.second );

            if ( p.first == direction ) {
                return goto( p.second );
            }
        }

        print( "You cannot go there" );
    }

    public void goto( string location ) modify {
        foreach ( Room r : rooms ) {
            if ( r == location ) {
                player.location = location;

                currentRoom = r;

                print( currentRoom.name + ":" );
                print( currentRoom.description );

                break;
            }
        }
    }

    public void inventory() {
        foreach ( string i : player.inventory ) {
            print( "You have a " + i );
        }
    }

    public void look( string item ) {
        if ( !item ) {
            // look at room
            print( currentRoom.description );
            print( "" );

            foreach ( string i : currentRoom.items ) {
                print( "You see a " + i );
            }

            foreach ( Pair<string, string> p : currentRoom.exits ) {
                print( "From here you can go " + p.first );
            }

            return;
        }

        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "[" + currentRoom.name + "] You are looking at " + i );
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                print( "[Inventory] You are looking at " + i );
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    public void take( string item ) modify {
        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "[" + currentRoom.name + "] You are picking up " + i );

                currentRoom.items.erase( currentRoom.items.indexOf( item ) );
                player.inventory.push_back( i );
                return;
            }
        }

        print( "There is no " + item + " in the room." );
    }

    public void use( string item ) modify {
        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "[" + currentRoom.name + "] You are looking at " + i );
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                print( "[Inventory] You are looking at " + i );
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    private void load() modify {
        loadPlayer();
        loadRooms();
        loadSynonyms();

        print( "" );

        goto( player.location );
    }

    private JsonValue loadFile( string filename ) const {
        var reader = new JsonReader();
        var data = reader.parse( new Scanner( filename ).getText() );

        var writer = new JsonStyledWriter();
        //print( writer.toString( data ) );

        return data;
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

                    foreach ( Pair<string, string> p : room.exits ) {
                        print( room.name + ": " + cast<string>( p ) );
                    }
                }
                {   // items
                    foreach ( JsonValue item : JsonArray r[ "items" ] ) {
                        room.items.push_back( item.asString() );

                        print( room.name + ": " + item.asString() + " [item]" );
                    }
                }
                {   // npcs
                    foreach ( JsonValue npc : JsonArray r[ "npcs" ] ) {
                        room.npcs.push_back( npc.asString() );

                        print( room.name + ": " + npc.asString() + " [npc]" );
                    }
                }
            }

            rooms.push_back( room );
        }
    }

    private void loadSynonyms() modify {
        var data = loadFile( "data/synonyms.json" );

        var writer = new JsonStyledWriter();
        //print( writer.toString( data ) );

        // TODO: implement sysnonym loading
    }
}
