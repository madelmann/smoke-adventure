
// library imports
import System.Collections.Vector;

// project imports


/*
"id": "locker",
"name": "locker",
"description": "A locked metal locker, paint flaking. There's a faint ticking from within.",
"usable": false,
"locked": true,
"requires_item": "locker_key",
"contains": ["ledger"]
*/

public object Item
{
    public Vector<string> contains;
    public string description;
    public string id;
    public bool locked;
    public string name;
    public string requiresItem;
    public bool usable;
    public bool useEffect;

    public static Item parse( JsonValue data ) {
        var item = new Item() {
            var i = JsonObject data;

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

        return item;
    }

    public void Constructor() {
        contains = new Vector<string>();
    }

    public void Print() const {
        print( "ID: " + id );
        print( "Name: " + name );
        print( "Description: " + description );
        print( "Locked: " + locked );
        print( "Usable: " + usable );
        print( "RequiresItem: " + requiresItem );
        print( "Usable: " + usable );
        print( "Contains:" );
        foreach ( string content : contains ) {
            print( "   " + content );
        }
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }

    public string =operator( string ) const {
        return id + " | " + name + " | " + description;
    }
}
