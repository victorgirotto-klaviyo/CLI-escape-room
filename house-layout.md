# Scenario

You are locked inside a decrepit mannor whose only exit is an automatic door that doesn't have power. It's night time. There is a full moon outside and the constant sound of crows. Cobwebs and rats everywhere. The whole vibe is a creepy but fun setting, similar to the game Luigi's mansion (but don't make any references to the game, it's just a vibe reference).

# Objective

The user has to collect three power cells to power up the door and place them in the front door's generator. They can do that by finding the cells in each room and moving them (with `mv`) to the Door generator in the lobby.

# Basic structure

**Rooms** are represented as a set of nested directories. Users can navigate through `cd` and `ls`.

**Objects** are represented by text files. The content of these text files is a description of the object that users can access using `cat`. Unless I add a description following the object's name, I want you to generate a short description for the object. It should be creative, descriptive, and help set the mood as described in the scenario section.

Some objects can have other objects inside of it. In this case, they are represented as a directory as well.

**Actions** are bash scripts in each room. Users can run bash scripts through `./{file_name}`. Each bash script should have a matching description accessible through `man`.


# House layout

* Mannor lobby
    * 2nd floor
        * Guest room
        * Master suite
    * Kitchen
        * Pantry
    * Living room
        * Secret room

# Lobby

The lobby is the central area in the mannor. It has access to the 2nd floor, the kitchen, and the living room.

Objects:
* Entry console
* Door generator (directory)

Actions:
* Open door: Opens the door when the Door generator directory has the three power cell files inside of it. Otherwise, it just gives out a message saying "Power cells missing. Insufficient power." When all the power cells are in the Door generator, the action will create a new directory called "Street". 

# Kitchen

Objects:
* Sink
* Dining table
* Frigde
* Dishwasher
* [Add at most 3 other appropriate objects to this room]
* Rubble: this [TODO]

Actions:
* Open pantry door: This action opens the pantry door. But it only does so if the Rubble object has been removed (through `rm`). If it hasn't been, running this action should ouput ("The door can't be opened. The rubble is in the way"). If the rubble has already been removed, it should create the Pantry directory with the `Power Cell 1` object inside of it.

# Pantry

Objects:
* Generate some random food items with interesting or funny descriptions that fit the vibe
* Power Cell 1

# Living room

Objects:
* Piano
* Sofa
* Chair
* Mirror
* Bookcase (this is a directory object): 
    * Generate a list of 15 books that fit the vibe of the scenario.
    * Note: "This bookshelf contains more than knowledge. Make sure to look closely for **hidden* secrets!"
    * .Open secret room (action). This action is a hidden file (i.e. it's named with a preceding .). When executed, it will create the Secret room directory and display "A new door has appeared in the living room" 

# Secret room

Objects:
* Power Cell 2

# Guest room

Objects:
* Bed
* Nightstand
* Luggage
* Note: "0131"

# Master suite

Objects:
* Bed
* Nightstand
* Desk 
* Safe

Actions:
* Open safe: this will open the safe. But this script requires an argument, the 4-digit number found in the note in the guest room (0131), to open. If no argument is supplied, notify the user "You must supply a code". If the wrong code is given, notify the user "Wrong code". If the correct code is supplied, Create the "Power Cell 3" object inside of the Master suite and notify the user ("The safe is open and the Power Cell 3 rolled out of it into the room").

# Street

Actions:
* Run away: this command will play an ASCII animation of a character dressed like Indiana Jones running. Below that, it says "YOU ESCAPED!"In big ASCI art. Below that, in normal text, it should say "Press ctrl+c to close" in regular font. Pressing ctrl+c will close this animation.

