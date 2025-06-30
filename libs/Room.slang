
/*
    "id": "bar",
    "name": "The Blue Note",
    "description": "A smoky jazz club with a lingering air of secrets. A piano plays in the corner. Mick polishes glasses behind the counter.",
    "exits": {
      "west": "office",
      "south": "docks"
    },
    "items": ["bourbon"],
    "npcs": ["mick"]
*/

// library imports
import System.Collections.Map;
import System.Collections.Vector;

// project imports


public object Room
{
    public string description;
    public Map<string, string> exits;
    public string id;
    public Vector<string> items;
    public string name;
    public Vector<string> npcs;

    public void Constructor() {
        exits = new Map<string, string>();
        items = new Vector<string>();
        npcs  = new Vector<string>();
    }

    public bool operator==( string id_ ) const {
        return id == id_;
    }
}
