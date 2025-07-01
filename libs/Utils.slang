
// library imports
import libJson;

// project imports


private JsonValue loadFile( string filename ) const {
    var reader = new JsonReader();
    var data = reader.parse( new Scanner( filename ).getText() );

    var writer = new JsonStyledWriter();
    //print( writer.toString( data ) );

    return data;
}

