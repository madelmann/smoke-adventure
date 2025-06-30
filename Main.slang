#!/usr/bin/env slang

// library imports
import System.String;

// project imports
import libs.Consts;
import libs.World;


public void Main( int argc, string args )
{
    var world = new World();

    while ( true ) {
        cout( "> " );
        var input = new String( cin() );

        // TODO: replace input with synonyms, so that only our commands are returned,
        //       but make sure to only replace the whole token if a space is following
        //       or it is at the end of the input

        // process input
        var tokenIt = input.SplitBy( " " );
        if ( tokenIt.hasNext() ) {
            var command = tokenIt++;

            if ( command == "exit" ) {
                break;
            }
            else if ( command == "give" ) {
                var item = tokenIt++;
                string to;
                if ( tokenIt.hasNext() ) {
                    to = tokenIt++;
                }

                world.give( item, to );
            }
            else if ( command == "go" ) {
                var direction = tokenIt++;

                world.go( direction );
            }
            else if ( command == "inventory" ) {
                world.inventory();
            }
            else if ( command == "look" ) {
                string item;
                if ( tokenIt.hasNext() ) {
                    item = tokenIt++;
                }

                world.look( item );
            }
            else if ( command == "take" ) {
                var item = tokenIt++;

                world.take( item );
            }
            else if ( command == "use" ) {
                var item = tokenIt++;

                world.use( item );
            }
        }
    }
}
