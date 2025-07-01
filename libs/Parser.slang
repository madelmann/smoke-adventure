
// library imports
import System.String;

// project imports
import libs.Synonyms;
import libs.World;


public object Parser
{
    public void Constructor() {
        synonyms = new Synonyms();
        world    = new World() {
            player = world.player;
        }
    }

    public void run() modify {
        goto( player.location );

        while ( true ) {
            cout( "> " );
            var input = new String( cin() );

            synonyms.prepare( input );

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
                    string direction;
                    if ( tokenIt.hasNext() ) {
                        direction = tokenIt++;
                    }

                    go( direction );
                }
                else if ( command == "help" ) {
                    printHelp();
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
                return;
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
                return;
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                print( "[Inventory] You are looking at " + i );
                return;
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    private void printHelp() {
        print( "Supported commands:" );
        print( "" );
        print( "exit" );
        print( "give" );
        print( "go" );
        print( "help" );
        print( "inventory" );
        print( "look" );
        print( "take" );
        print( "use" );
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
                return;
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                print( "[Inventory] You are looking at " + i );
                return;
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    private Player player;
    private Room currentRoom;
    private Synonyms synonyms;
    private World world;
}