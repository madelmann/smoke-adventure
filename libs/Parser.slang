
// library imports
import System.String;

// project imports
import libs.World;


public object Parser
{
    public void Constructor() {
        world = new World();

        currentRoom = world.currentRoom;
        player      = world.player;
    }

    public void run() modify {
        goto( player.location );

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

                    give( item, to );
                }
                else if ( command == "go" ) {
                    var direction = tokenIt++;

                    go( direction );
                }
                else if ( command == "inventory" ) {
                    inventory();
                }
                else if ( command == "look" ) {
                    string item;
                    if ( tokenIt.hasNext() ) {
                        item = tokenIt++;
                    }

                    look( item );
                }
                else if ( command == "take" ) {
                    var item = tokenIt++;

                    take( item );
                }
                else if ( command == "use" ) {
                    var item = tokenIt++;

                    use( item );
                }
            }
        }
    }


    private void give( string item, string to ) modify {
        if ( !player.inventory.contains( item ) ) {
            print( "You don't have a " + item );
            return;
        }

        foreach ( string n : currentRoom.npcs ) {
            if ( n == to ) {
                print( "You are giving " + item + " to " + n );

                player.inventory.erase( player.inventory.indexOf( item ) );

                // TODO: implement give action
                return;
            }
        }
    }

    private void go( string direction ) modify {
        foreach ( Pair<string, string> p : currentRoom.exits ) {
            //print( currentRoom.name + ": " + p.first + " => " + p.second );

            if ( p.first == direction ) {
                return goto( p.second );
            }
        }

        print( "You cannot go there" );
    }

    private void goto( string location ) modify {
        foreach ( Room r : world.rooms ) {
            if ( r == location ) {
                player.location = location;

                currentRoom = r;

                print( currentRoom.name + ":" );
                print( currentRoom.description );

                break;
            }
        }
    }

    private void inventory() {
        foreach ( string i : player.inventory ) {
            print( "You have a " + i );
        }
    }

    private void look( string item ) {
        if ( !item ) {
            // look at room
            print( currentRoom.description );
            print( "" );

            foreach ( string i : currentRoom.items ) {
                print( "You see a " + i );
            }

            foreach ( Pair<string, string> p : currentRoom.exits ) {
                print( "From here you can go " + p.first );
            }

            return;
        }

        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "[" + currentRoom.name + "] You are looking at " + i );
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                print( "[Inventory] You are looking at " + i );
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    private void take( string item ) modify {
        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "[" + currentRoom.name + "] You are picking up " + i );

                currentRoom.items.erase( currentRoom.items.indexOf( item ) );
                player.inventory.push_back( i );
                return;
            }
        }

        print( "There is no " + item + " in the room." );
    }

    private void use( string item ) modify {
        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "[" + currentRoom.name + "] You are looking at " + i );
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                print( "[Inventory] You are looking at " + i );
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    private Player player;
    private Room currentRoom;
    private World world;
}