
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

    public void Constructor() {
        contains = new Vector<string>();
    }
}
