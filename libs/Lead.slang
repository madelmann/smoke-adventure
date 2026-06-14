
// library imports
import System.Collections.Vector;

// project imports


/*
"id": "locker_413",
"title": "Locker #413",
"description": "Mick mentioned a locker at the station.",
"discovered_by": [
    "locker_clue"
]
*/

public object Lead
{
    public Vector<string> discoveredBy;
    public string description;
    public string id;
    public string title;

    public static Lead parse( JsonValue data )
    {
        var lead = new Lead() {
            var i = JsonObject data;

            lead.description  = i[ "description" ].asString();
            lead.id           = i[ "id" ].asString();
            lead.title        = i[ "title" ].asString();

            if ( i.isMember( "discoveredBy" ) ) {
                foreach ( JsonValue s : JsonArray i[ "discoveredBy" ] ) {
                    lead.discoveredBy.push_back( s.asString() );
                }
            }
        }

        return lead;
    }

    public void Constructor()
    {
        discoveredBy = new Vector<string>();
    }

    public void Print() const
    {
        print( "ID: " + id );
        print( "Title: " + title );
        print( "Description: " + description );
        print( "discoveredBy:" );
        foreach ( string content : discoveredBy ) {
            print( "   " + content );
        }
    }

    public bool operator==( string id_ ) const
    {
        return id == id_;
    }

    public string =operator( string ) const
    {
        return id + " | " + title + " | " + description;
    }
}
