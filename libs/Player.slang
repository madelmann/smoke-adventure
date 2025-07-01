
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

    public void Constructor() {
        flags     = new Vector<string>();
        inventory = new Vector<string>();
    }
}
