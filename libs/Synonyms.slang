
// library imports
import System.Collections.Vector;
import System.Collections.Map;
import String;

// project imports
import Utils;


public object Synonyms
{
    public void Constructor() {
        loadSynonyms();
    }

    public void prepare( String input ) {
        // replace input with synonyms, so that only our commands are returned,
        // but make sure to only replace the whole token if a space is following
        // or it is at the end of the input

        bool replaced = false;

        foreach ( string verb : synGive ) {
            replaced = input.Replace( verb, "give" ) || replaced;
        }
        foreach ( string verb : synGo ) {
            replaced = input.Replace( verb, "go" ) || replaced;
        }
        foreach ( string verb : synLook ) {
            replaced = input.Replace( verb, "look" ) || replaced;
        }
        foreach ( string verb : synTalk ) {
            replaced = input.Replace( verb, "talk" ) || replaced;
        }
        foreach ( string verb : synTake ) {
            replaced = input.Replace( verb, "take" ) || replaced;
        }
        foreach ( string verb : synUse ) {
            replaced = input.Replace( verb, "use" ) || replaced;
        }
    }

    private void loadSynonyms() modify {
        var data = JsonObject loadFile( "data/synonyms.json" );

        var writer = new JsonStyledWriter();
        // print( writer.toString( data ) );

        synGive = new Vector<string>();
        foreach ( JsonValue verb : JsonArray data[ "give" ] ) {
            synGive.push_back( verb.asString() );
        }
    
        synGo = new Vector<string>();
        foreach ( JsonValue verb : JsonArray data[ "go" ] ) {
            synGo.push_back( verb.asString() );
        }

        synLook = new Vector<string>();
        foreach ( JsonValue verb : JsonArray data[ "look" ] ) {
            synLook.push_back( verb.asString() );
        }

        synTake = new Vector<string>();
        foreach ( JsonValue verb : JsonArray data[ "take" ] ) {
            synTake.push_back( verb.asString() );
        }

        synTalk = new Vector<string>();
        foreach ( JsonValue verb : JsonArray data[ "talk" ] ) {
            synTalk.push_back( verb.asString() );
        }

        synUse = new Vector<string>();
        foreach ( JsonValue verb : JsonArray data[ "use" ] ) {
            synUse.push_back( verb.asString() );
        }
    }

    private Vector<string> synGive;
    private Vector<string> synGo;
    private Vector<string> synLook;
    private Vector<string> synTake;
    private Vector<string> synTalk;
    private Vector<string> synUse;
}
