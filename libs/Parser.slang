
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
        print( world.intro );

        goto( player.location );

        while ( true ) {
            cout( "> " );
            var input = new String( cin() );

            synonyms.prepare( input );

            // process input
            var tokenIt = input.SplitBy( " " );
            if ( tokenIt.hasNext() ) {
                var command = tokenIt++;

                if ( command == "give" ) {
                    var item = tokenIt++;
                    string to;
                    if ( tokenIt.hasNext() ) {
                        to = tokenIt++;
                    }

                    give( item, to );
                }
                else if ( command == "go" ) {
                    if ( tokenIt.hasNext() ) {
                        go( tokenIt++ );
                    }
                }
                else if ( command == "help" ) {
                    printHelp();
                }
                else if ( command == "inventory" ) {
                    inventory();
                }
                else if ( command == "load" ) {
                    world.load();

                    goto( player.location );
                }
                else if ( command == "look" ) {
                    string item;
                    if ( tokenIt.hasNext() ) {
                        item = tokenIt++;
                    }

                    look( item );
                }
                else if ( command == "quit" ) {
                    break;
                }
                else if ( command == "save" ) {
                    world.save();
                }
                else if ( command == "take" ) {
                    string item;
                    if ( tokenIt.hasNext() ) {
                        item = tokenIt++;
                    }

                    take( item );
                }
                else if ( command == "use" ) {
                    string item;
                    if ( tokenIt.hasNext() ) {
                        item = tokenIt++;
                    }

                    use( item );
                }
                // debug only - begin
                else if ( command == "locations" ) {
                    locations();
                }
                else if ( command == "teleport" ) {
                    goto( tokenIt++ );
                }
                // debug only - end
                else {
                    print( "Unsupported command '" + command + "'" );
                }

                print( "" );
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

                print( "- " + currentRoom.name + " -" );
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

    private void locations() {
        foreach ( Room r : world.rooms ) {
            print( r.id + " | " + r.name + " | " + r.description );
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

            foreach ( string n : currentRoom.npcs ) {
                print( "You see " + n );
            }

            return;
        }

        item = toLower( item );

        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                lookAtItem( item );
                return;
            }
        }

        foreach ( string n : currentRoom.npcs ) {
            if ( n == item ) {
                lookAtNPC( item );
                return;
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                lookAtItem( item );
                return;
            }
        }

        print( "There is no " + item + " in the room or your inventory." );
    }

    private void lookAtItem( string id ) throws {
        foreach ( Item i : world.items ) {
            if ( i.id == id ) {
                print( i.description );
                return;
            }
        }

        throw "Item '" + id + "' not found!";
    }

    private void lookAtNPC( string id ) throws {
        foreach ( NPC n : world.npcs ) {
            if ( n.id == id ) {
                print( n.description );
                return;
            }
        }

        throw "NPC '" + id + "' not found!";
    }

    private void printHelp() {
        print( "Supported commands:" );
        print( "load" );
        print( "save" );
        print( "quit" );
        print( "- game -" );
        print( "give" );
        print( "go" );
        print( "inventory" );
        print( "look" );
        print( "take" );
        print( "talk" );
        print( "use" );
        print( "- debug - " );
        print( "locations" );
        print( "teleport" );
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

        print( "You can't take that." );
    }

    private void use( string item ) modify {
        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                useItem( item );
                return;
            }
        }

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                useItem( item );
                return;
            }
        }

        print( "You can't do that." );
    }

    private void useItem( string id ) modify throws {
        foreach ( Item i : world.items ) {
            if ( i.id == id ) {
                if ( !i.usable ) {
                    print( "You cannot do that." );
                    return;
                }

                if ( i.locked ) {
                    print( "It is locked." );
                    return;
                }

                if ( i.requiresItem ) {
                    if ( !player.inventory.contains( i.requiresItem ) ) {
                        print( "You are missing an item (" + i.requiresItem + ")" );
                        return;
                    }
                }

                if ( !i.contains.empty() ) {
                    foreach ( string c : i.contains ) {
                        print( "It contains a " + c );

                        i.contains.erase( i.contains.indexOf( c ) );

                        currentRoom.items.push_back( c );
                    }
                    // foreach ( string c : i.contains ) {
                    //     i.contains.remove( c );
                    // }
                }

                i.usable = false;   // items can only be used once, in order to be re-used they need to be reset by a trigger
                return;
            }
        }

        throw "Item '" + id + "' not found!";
    }

    private Player player;
    private Room currentRoom;
    private Synonyms synonyms;
    private World world;
}