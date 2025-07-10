
// library imports
import System.Collections.Vector;

// project imports


/*
"location": "detective_office",
"inventory": ["detective hat", "music_box", "locker_key"],
"flags": ["found_cufflink"]
*/

public object Player
{
    public Vector<string> flags;
    public Vector<string> inventory;
    public string location;

    public static Player parse( JsonValue data ) {
        var player = new Player() {
            var p = JsonObject data;

            foreach ( JsonValue flag : JsonArray p[ "flags" ] ) {
                player.flags.push_back( flag.asString() );
            }
            foreach ( JsonValue item : JsonArray p[ "inventory" ] ) {
                player.inventory.push_back( item.asString() );
            }
            player.location = p[ "location" ].asString();
        }

        return player;
    }

    public void Constructor() {
        flags     = new Vector<string>();
        inventory = new Vector<string>();
    }
}
