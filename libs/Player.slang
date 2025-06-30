
// library imports
import System.Collections.Vector;

// project imports


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
