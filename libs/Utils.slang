
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
        filename = "save/" + filename;
    }

    return reader.parse( loadFile( filename ) );
}

private void storeFile( string filename, string content ) const {
    var file = new System.IO.File( filename, System.IO.File.AccessMode.WriteOnly ) {
        file.write( content );
        file.close();
    }
}


private namespace {

    void debug( string message ) {
        print( "DEBUG: " + message );
    }

}

