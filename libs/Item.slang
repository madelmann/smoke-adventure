
// library imports
import System.Collections.Vector;

// project imports


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
