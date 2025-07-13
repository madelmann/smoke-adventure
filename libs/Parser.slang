
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
                else if ( command == "talk" ) {
                    string item;
                    if ( tokenIt.hasNext() ) {
                        item = tokenIt++;
                    }

                    talk( item );
                }
                else if ( command == "use" ) {
                    string item;
                    if ( tokenIt.hasNext() ) {
                        item = tokenIt++;
                    }

                    string with;
                    if ( tokenIt.hasNext() ) {
                        with = tokenIt++;
                    }

                    use( item, with );
                }
                // debug only - begin
                else if ( command == "debug" ) {
                    printDebug();
                }
                else if ( command == "events" ) {
                    events();
                }
                else if ( command == "items" ) {
                    items();
                }
                else if ( command == "npcs" ) {
                    npcs();
                }
                else if ( command == "rooms" ) {
                    rooms();
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

    private void events() {
        print( "id | room | item | triggered" );

        foreach ( Event e : world.events ) {
            print( e.id + " | " + e.room + " | " + e.item + " | " + e.triggered );
        }
    }

    private void executeEvent( Event event ) modify {
        if ( !event || ( event.triggered && !event.repeat ) ) {
            return;
        }

        foreach ( string flag : event.requireFlag ) {
            if ( !player.flags.contains( flag ) ) {
                debug( "Player does not have required flag '" + flag + "'" );
                return;
            }
        }

        foreach ( string item : event.requireItem ) {
            if ( !player.inventory.contains( item ) ) {
                debug( "Player does not have required item '" + item + "'" );
                return;
            }
        }

        event.triggered = true;

        foreach ( string flag : event.effectFlag ) {
            if ( !player.flags.contains( flag ) ) {
                player.flags.push_back( flag );
            }
        }
        foreach ( string flag : event.effectUnflag ) {
            player.flags.erase( player.flags.indexOf( flag ) );
        }

        print( event.effectText );
    }

    private void give( string item, string to ) modify {
        if ( !player.inventory.contains( item ) ) {
            print( "You don't have a " + item );
            return;
        }

        foreach ( string npc : currentRoom.npcs ) {
            if ( npc == to ) {
                print( "You are giving " + item + " to " + npc );

                player.inventory.erase( player.inventory.indexOf( item ) );

                // TODO: implement give action
                return;
            }
        }
    }

    private void go( string direction ) modify {
        foreach ( Pair<string, string> p : currentRoom.exits ) {
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
                print( "" );

                return executeEvent( world.getEvent( "enter_room", "", r.id ) );
            }
        }
    }

    private void inventory() {
        foreach ( string i : player.inventory ) {
            print( "You have a " + i );
        }
    }

    private void items() {
        print( "id | name | description" );

        foreach ( Item i : world.items ) {
            print( i.id + " | " + i.name + " | " + i.description );
        }
    }

    private void rooms() {
        print( "id | name | description" );

        foreach ( Room r : world.rooms ) {
            print( r.id + " | " + r.name + " | " + r.description );
        }
    }

    private void look( string item ) {
        if ( !item ) {
            // look at room
            print( currentRoom.description );
            print( "" );

            foreach ( string n : currentRoom.npcs ) {
                print( "You see " + n );
            }

            foreach ( string i : currentRoom.items ) {
                print( "You see a " + i );
            }

            foreach ( Pair<string, string> p : currentRoom.exits ) {
                print( "From here you can go " + p.first );
            }

            return;
        }

        item = toLower( item );

        foreach ( string i : player.inventory ) {
            if ( i == item ) {
                lookAtItem( item );
                return;
            }
        }

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

        print( "There is no " + item + " in the room or your inventory." );
    }

    private void lookAtItem( string id ) {
        var item = world.getItem( id );

        print( item.description );
    }

    private void lookAtNPC( string id ) {
        var npc = world.getNPC( id );

        print( npc.description );
    }

    private void npcs() {
        print( "id | name | description" );

        foreach ( NPC n : world.npcs ) {
            print( n.id + " | " + n.name + " | " + n.description );
        }
    }

    private void printDebug() {
        foreach ( string flag : player.flags ) {
            print( "Flag: " + flag );
        }
        foreach ( string item : player.inventory ) {
            print( "Item: " + item );
        }
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
        print( "debug" );
        print( "events" );
        print( "items" );
        print( "npcs" );
        print( "rooms" );
        print( "teleport" );
    }

    private void take( string item ) modify {
        foreach ( string i : currentRoom.items ) {
            if ( i == item ) {
                print( "You are picking up " + i );

                currentRoom.items.erase( currentRoom.items.indexOf( item ) );

                // silently ignore already owned items
                if ( !player.inventory.contains( i ) ) {
                    player.inventory.push_back( i );
                }

                return;
            }
        }

        print( "You can't take that." );
    }

    private void talk( string npc ) modify {
        foreach ( string n : currentRoom.npcs ) {
            if ( n == npc ) {
                try {
                    return dialogue( world.getNPC( npc ), "intro" );
                }
            }
        }

        print( "You can't do that." );
    }

    private void dialogue( NPC npc, string entry ) modify {
        foreach ( Pair<string, Dialogue> p : npc.dialogue ) {
            if ( p.first == entry ) {
                if ( p.second.setFlag && !player.flags.contains( p.second.setFlag ) ) {
                    player.flags.push_back( p.second.setFlag );
                }
                if ( p.second.setItem && !player.inventory.contains( p.second.setItem ) ) {
                    player.inventory.push_back( p.second.setItem );
                }

                print( p.second.text );

                if ( p.second.choices.size() ) {
                    foreach ( Pair<int, Choice> c : p.second.choices ) {
                        print( "" + ( c.first + 1 ) + ": " + c.second.text );
                    }

                    write( "Say: " );
                    var choiceIdx = cast<int>( cin() ) - 1;

                    foreach ( Pair<int, Choice> c : p.second.choices ) {
                        if ( c.first == choiceIdx ) {
                            return dialogue( npc, c.second.next );
                        }
                    }
                }

                return;
            }
        }
    }

    private void use( string item, string with ) modify {
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
                        debug( "You are missing an item (" + i.requiresItem + ")" );
                        return;
                    }
                }

                executeEvent( world.getEvent( "examine", i.id, "" ) );

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