
/*
"id": "bar",
"name": "The Blue Note",
"description": "A smoky jazz club with a lingering air of secrets. A piano plays in the corner. Mick polishes glasses behind the counter.",
"exits": {
    "west": { "id": "office" },
    "south": { "id: "docks" }
},
"items": ["bourbon"],
"npcs": ["mick"],
"require_item": null,
"require_flag": null
*/

// library imports
import System.Collections.Map;
import System.Collections.Vector;

// project imports


public object Exit
{
    public string requireFlag;
    public string requireItem;
    public string roomId;

    public static Exit parse( JsonValue data )
    {
        var roomExit = new Exit() {
            var r = JsonObject data;

            roomExit.roomId = r[ "id" ].asString();

            if ( r.isMember( "require_flag" ) ) {
                roomExit.requireFlag = r[ "require_flag" ].asString();
            }
            if ( r.isMember( "require_item" ) ) {
                roomExit.requireItem = r[ "require_item" ].asString();
            }
        }

        return roomExit;
    }

    public string =operator( string ) const
    {
        return roomId + " | " + requireFlag + " | " + requireItem;
    }
}

public object Room
{
    public string description;
    public Map<string, Exit> exits;
    public string id;
    public Vector<string> items;
    public string name;
    public Vector<string> npcs;

    public static Room parse( JsonValue data )
    {
        var room = new Room() {
            var r = JsonObject data;

            room.description = r[ "description" ].asString();
            room.id          = r[ "id" ].asString();
            room.name        = r[ "name" ].asString();

            if ( r.isMember( "exits" ) ) {
                foreach ( Pair<string, JsonValue> p : JsonObject r[ "exits" ] ) {
                    room.exits.insert( p.first, Exit.parse( p.second ) );
                }
            }
            if ( r.isMember( "items" ) ) {
                foreach ( JsonValue item : JsonArray r[ "items" ] ) {
                    room.items.push_back( item.asString() );
                }
            }
            if ( r.isMember( "npcs" ) ) {
                foreach ( JsonValue npc : JsonArray r[ "npcs" ] ) {
                    room.npcs.push_back( npc.asString() );
                }
            }
        }

        return room;
    }

    public void Constructor()
    {
        exits = new Map<string, Exit>();
        items = new Vector<string>();
        npcs  = new Vector<string>();
    }

    public void Print() const
    {
        print( "ID: " + id );
        print( "Name: " + name );
        print( "Description: " + description );
        print( "Exits:" );
        foreach ( Pair<string, string> e : exits ) {
            print( "   " + cast<string>( e ) );
        }
        print( "Items:" );
        foreach ( string item : items ) {
            print( "   " + item );
        }
        print( "NPCs:" );
        foreach ( string npc : npcs ) {
            print( "   " + npc );
        }
    }

    public bool operator==( string id_ ) const
    {
        return id == id_;
    }

    public string =operator( string ) const
    {
        return id + " | " + name + " | " + description;
    }
}
