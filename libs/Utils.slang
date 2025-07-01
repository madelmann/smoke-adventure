
// library imports
import libJson;

// project imports


private string loadFile( string filename ) const {
    return new Scanner( filename ).getText();
}

private JsonValue loadJson( string filename ) const {
    var reader = new JsonReader();

    string content;
    if ( System.IO.File.Exists( "save/" + filename ) ) {
        content = loadFile( "save/" + filename );
    }
    else {
        content = loadFile( filename );
    }

    var data = reader.parse( content );

    //var writer = new JsonStyledWriter();
    //print( writer.toString( data ) );

    return data;
}

private void storeFile( string filename, string content ) const {
    var file = new System.IO.File( filename, System.IO.File.AccessMode.WriteOnly );
    file.write( content );
}

