#!/usr/bin/env bash
# ================================================================
#  MANOR ESCAPE — Game Setup Script
#  Run this script to generate the full game directory.
#  Usage: bash setup.sh
# ================================================================
set -e

GAME_DIR="manor"

if [ -d "$GAME_DIR" ]; then
    echo "⚠️  '$GAME_DIR' already exists. Remove it first: rm -rf $GAME_DIR"
    exit 1
fi

echo "🏚️  Setting up Manor Escape..."
mkdir -p "$GAME_DIR"
cd "$GAME_DIR"

# ================================================================
# README
# ================================================================
cat > README.txt << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║             MANOR ESCAPE  —  A Terminal Mystery            ║
╚═══════════════════════════════════════════════════════════╝

You are locked inside a decrepit manor. It is night.
A full moon hangs overhead, and the constant sound of crows
fills the air. Cobwebs cling to everything. Rats dart through
the walls.

The only exit is an automatic door at the end of the lobby —
but it has no power.

─────────────────────────────────────────────────────────────
OBJECTIVE
Find the three power cells hidden throughout the manor and
move them into the door_generator here in the lobby.
Then activate the door mechanism.
─────────────────────────────────────────────────────────────
COMMANDS
  ls                  See what's in the current room
  ls -a               See everything, including hidden items
  cd <room>           Enter a room
  cd ..               Go back
  cat <object>        Examine an object
  mv <item> <dest>    Move an item somewhere
  rm <item>           Remove an item
  touch <file>        Create a new file
  ./<action>          Run an action in the current room
  ./<action> --help   Read instructions for an action
─────────────────────────────────────────────────────────────

Good luck. The crows are watching.
EOF

# ================================================================
# LOBBY
# ================================================================

cat > entry_console.txt << 'EOF'
A mahogany console sits near the entrance, its surface thick with dust.
A brass nameplate reads "WHITMORE ESTATE — SECURITY PANEL."
The screen flickers faintly, cycling through a single message on repeat:

  > MAIN DOOR: OFFLINE
  > BACKUP POWER: NOT DETECTED
  > STATUS: LOCKED

A crow has made its nest on top of it. It stares at you without blinking.
EOF

mkdir -p door_generator

cat > door_generator/note.txt << 'EOF'
The door generator. Three circular slots wait to be filled.
Each slot is labeled: CELL-1 / CELL-2 / CELL-3.
Right now, they are all empty. The mechanism is completely silent.
EOF

# ── ACTION: open_door.sh ──────────────────────────────────────
cat > open_door.sh << 'EOF'
#!/usr/bin/env bash
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: ./open_door.sh"
    echo ""
    echo "Attempts to activate the manor's automatic door."
    echo "The door runs on backup power — it needs something to power it."
    echo "Find what the generator is missing and bring it here."
    exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GEN="$SCRIPT_DIR/door_generator"

missing=()
for cell in power_cell_1 power_cell_2 power_cell_3; do
    [ ! -f "$GEN/$cell" ] && missing+=("$cell")
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "⚡ Power cells missing. Insufficient power."
    printf "   Installed: %d/3\n" "$((3 - ${#missing[@]}))"
    echo ""
    echo "   Still missing:"
    for m in "${missing[@]}"; do echo "     — $m"; done
    exit 1
fi

echo ""
echo "⚡ ⚡ ⚡  All power cells detected..."
sleep 0.8
echo "🔋  Initializing backup power..."
sleep 0.8
echo "⚙️   Systems coming online..."
sleep 1
echo ""
echo "The floor vibrates. A deep mechanical groan rises from beneath you."
sleep 0.6
echo "The lights flicker once. A heavy CLUNK from the end of the lobby."
sleep 0.8
echo "The automatic door shudders, strains..."
sleep 0.6
echo ""
echo "...and slowly, finally, OPENS."
sleep 0.5
echo ""
echo "A cold night breeze floods in. The crows fall completely silent."
echo ""
echo "The street is right there."
echo ""
echo "→  Type 'cd street' to step outside."

cp -r "$SCRIPT_DIR/.staging/street" "$SCRIPT_DIR/street"
chmod +x "$SCRIPT_DIR/street/run_away.sh"
EOF
chmod +x open_door.sh

# ================================================================
# 2ND FLOOR — GUEST ROOM
# ================================================================
mkdir -p 2nd_floor/guest_room
mkdir -p 2nd_floor/master_suite

cat > 2nd_floor/guest_room/bed.txt << 'EOF'
A four-poster bed with a moth-eaten canopy, sagging at its centre.
The mattress holds a deep impression shaped to someone who slept here often
and stopped doing so without warning.
The pillow still holds the shape of a head.
EOF

cat > 2nd_floor/guest_room/nightstand.txt << 'EOF'
A small walnut nightstand, its single drawer left ajar —
as if whoever used it left in a hurry and didn't come back.
There's only a folded note inside.
EOF

cat > 2nd_floor/guest_room/luggage.txt << 'EOF'
A leather travel trunk plastered with faded destination stickers from cities
you've never heard of. The latches are rusted shut.
Whatever is inside has been there for a very long time.
Something shifts when you tilt it.
You decide not to tilt it again.
EOF

cat > 2nd_floor/guest_room/note.txt << 'EOF'
A small slip of paper, folded twice.
Written in careful, deliberate handwriting:

    0131

Below it, underlined twice:

    "Don't forget the code."
EOF

# ================================================================
# 2ND FLOOR — MASTER SUITE
# ================================================================

cat > 2nd_floor/master_suite/bed.txt << 'EOF'
The largest bed in the manor, draped in silk sheets that have turned grey
with dust. A velvet canopy the colour of dried blood sags overhead.
You have the distinct feeling you should not sit on it.
EOF

cat > 2nd_floor/master_suite/nightstand.txt << 'EOF'
A marble nightstand bearing a melted candle and a ring of hardened wax.
The drawer is empty. It smells of old paper and something you can't name
but don't enjoy.
EOF

cat > 2nd_floor/master_suite/desk.txt << 'EOF'
A mahogany writing desk buried under scattered, water-damaged papers.
Most are illegible. One dry page in the centre is covered only in:

    NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO
    NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO
    NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO

It fills the entire page. Both sides.
EOF

cat > 2nd_floor/master_suite/safe.txt << 'EOF'
A heavy iron safe, built flush into the wall behind a painting of someone
whose face has been carefully, methodically scratched out.
The combination dial is the only clean, polished object in this room —
as if it has been used recently.

It requires a 4-digit code.
Maybe someone else in the manor left a note.
EOF

# ── ACTION: open_safe.sh ──────────────────────────────────────
cat > 2nd_floor/master_suite/open_safe.sh << 'EOF'
#!/usr/bin/env bash
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: ./open_safe.sh <4-digit-code>"
    echo ""
    echo "Attempts to open the iron safe using a 4-digit code."
    echo "If the code is correct, something valuable will be revealed."
    echo "Someone in the manor may have written the code down."
    exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
    echo "You must supply a code."
    echo "Usage: ./open_safe.sh <4-digit-code>"
    exit 1
fi

if [ "$1" != "0131" ]; then
    echo "Wrong code."
    echo "The dial clicks back to zero."
    exit 1
fi

echo ""
echo "The dial aligns. Something deep inside the safe releases with a thunk."
sleep 0.6
echo "The door swings open on a long, low creak..."
sleep 0.8
echo ""
echo "The Power Cell 3 rolls out onto the floor, pulsing with faint blue light."
echo ""
echo "power_cell_3 has appeared in the master suite."

cat > "$SCRIPT_DIR/power_cell_3" << 'CELLEOF'
A cylindrical power cell, roughly the size of a thermos.
It pulses with a faint, steady blue glow — incongruously modern
against everything else in this room.

This goes in the door_generator in the lobby.
CELLEOF
EOF
chmod +x 2nd_floor/master_suite/open_safe.sh

# ================================================================
# KITCHEN
# ================================================================
mkdir -p kitchen

cat > kitchen/sink.txt << 'EOF'
A deep porcelain sink caked with years of grime.
The faucet drips steadily — each drop echoing like a slow heartbeat.
The basin holds a brownish ring of residue.
You tell yourself it's rust.
EOF

cat > kitchen/dining_table.txt << 'EOF'
A long oak table set for eight, as if guests were expected and never arrived.
Plates, tarnished silverware, wine glasses — all still in place.
The chairs are pulled back at odd angles, as though everyone stood up
at exactly the same moment and simply did not return.
EOF

cat > kitchen/fridge.txt << 'EOF'
A humming refrigerator, impossibly still functional after all this time.
The light inside still works. You open it exactly one inch,
register the smell, and close it again immediately.
Some things are better left sealed.
EOF

cat > kitchen/dishwasher.txt << 'EOF'
A rusted dishwasher, permanently frozen mid-cycle.
A line of blackened foam has dried along the door seal.
The display reads: "47 MINUTES REMAINING."
It has read this for years.
EOF

cat > kitchen/candle_holder.txt << 'EOF'
A wrought-iron candelabra holding seven half-melted candles.
Six are cold and unlit. The seventh flickers without any detectable source of wind.
You take two steps back.
EOF

cat > kitchen/rat_trap.txt << 'EOF'
A sprung rat trap with a piece of dried, fossilised cheese in the bait holder.
The mechanism fired — but whatever triggered it didn't take the cheese.
There are no tracks. Nothing to indicate what sprung it.
EOF

cat > kitchen/old_cookbook.txt << 'EOF'
"Mrs. Whitmore's Recipes for the Restless" — a handwritten cookbook
bound in cracked black leather.

The first recipe is titled: "Consommé for One Who Cannot Sleep."
The ingredient list ends mid-sentence.
The remaining pages are blank, except for the very last one:

    "Do not use the pantry after dark."
EOF

cat > kitchen/rubble.txt << 'EOF'
A section of the kitchen ceiling has given way —
plaster, lath, and rotted timber heaped directly against the pantry door.

The door handle is just visible underneath the debris,
but nothing is getting through until this rubble is cleared.
EOF

# ── ACTION: open_pantry_door.sh ───────────────────────────────
cat > kitchen/open_pantry_door.sh << 'EOF'
#!/usr/bin/env bash
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: ./open_pantry_door.sh"
    echo ""
    echo "Attempts to open the pantry door."
    echo "Something in this room is blocking the way."
    echo "The door won't budge until the path is clear."
    exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$SCRIPT_DIR/rubble.txt" ]; then
    echo "The door can't be opened. The rubble is in the way."
    exit 1
fi

if [ -d "$SCRIPT_DIR/pantry" ]; then
    echo "The pantry is already open."
    exit 0
fi

echo ""
echo "With the rubble cleared, the pantry door swings inward on its own."
sleep 0.5
echo "A wave of cold, stale air rolls out..."
sleep 0.8
echo ""
echo "The pantry is now accessible."

cp -r "$SCRIPT_DIR/.staging/pantry" "$SCRIPT_DIR/pantry"
EOF
chmod +x kitchen/open_pantry_door.sh

# ================================================================
# LIVING ROOM
# ================================================================
mkdir -p living_room/bookcase

cat > living_room/piano.txt << 'EOF'
A grand piano draped in a dusty sheet. When the wind shifts outside,
a single low note resonates from somewhere deep inside —
as if the instrument itself exhaled.
The fallboard is closed. You leave it that way.
EOF

cat > living_room/sofa.txt << 'EOF'
A Victorian sofa in faded burgundy velvet, sunken from decades of use.
The cushions hold the shape of someone who sat here often.
Something small and fast disappeared underneath it just before you looked.
EOF

cat > living_room/chair.txt << 'EOF'
A high-backed rocking chair, positioned precisely to face the fireplace.
It rocks slowly. On its own.
The fireplace behind it has been cold for years.
You do not sit in it.
EOF

cat > living_room/mirror.txt << 'EOF'
An ornate floor-length mirror in a gilded frame, tarnished to black.
Your reflection appears correct. It blinks in time with you.
It smiles slightly before you do.
You find somewhere else to stand.
EOF

cat > living_room/bookcase/note.txt << 'EOF'
A small card tucked between two volumes:

    "This bookcase contains more than knowledge.
     Make sure to look closely for hidden secrets!"

The handwriting is precise and deliberate.
EOF

# 15 books
cat > "living_room/bookcase/Everyone_Dies_Eventually-A_Comfort_Guide.txt" << 'EOF'
Author: C. Reaper

A warmly illustrated self-help guide with an incongruously cheerful cover.
The spine is heavily cracked from repeated reading. Several passages are
underlined. Every margin note says only "yes" or "yes, exactly."
EOF

cat > "living_room/bookcase/How_to_Make_Friends_and_Influence_Ghosts.txt" << 'EOF'
Author: D. Carnage

A professional networking guide for the spiritually adjacent.
Chapter 3, "Cold Introductions," is dog-eared.
The bookmark is a small bone. Not a reference to one. An actual one.
EOF

cat > "living_room/bookcase/Interior_Design_for_the_Undead.txt" << 'EOF'
Author: Unknown

A thick design manual full of floor plans for spaces that, on closer
inspection, have no doors. The aesthetic is described as "late decay, maximalist."
Somehow, the manor you're standing in is featured on page 47.
EOF

cat > "living_room/bookcase/1001_Ways_to_Disappear_Without_a_Trace.txt" << 'EOF'
Author: A. Nonymous

Thoroughly annotated. Multiple chapters are tabbed, highlighted, and in one
case, torn out entirely. The author photo has been blacked out with ink.
The caption beneath it reads: "The author cannot be reached for comment."
EOF

cat > "living_room/bookcase/Rats-A_Love_Story.txt" << 'EOF'
Author: Professor H. Whitmore (inscribed in the front)

A slim, passionate volume. The prose is unexpectedly tender.
Dedication: "To my only true companions. You know who you are."
There are scratch marks on the inside cover that appear to have been made
from inside the book. By something small. With claws.
EOF

cat > "living_room/bookcase/The_Complete_Idiots_Guide_to_Possession.txt" << 'EOF'
Author: For Dummies Press, Occult Division

A surprisingly practical reference guide with tabbed chapters and a
quick-start appendix. The troubleshooting section is heavily worn.
Someone wrote "DOES NOT WORK. TRIED IT." across the introduction in red.
Below it, in different handwriting: "try chapter 9."
EOF

cat > "living_room/bookcase/Cobwebs_and_Their_Cultural_Significance.txt" << 'EOF'
Author: Dr. E. Webb, PhD

576 pages. Lavishly illustrated. The acknowledgements section spans
four pages and thanks only spiders. By name.
EOF

cat > "living_room/bookcase/Dont_Open_That_Door-A_Memoir.txt" << 'EOF'
Author: [Redacted]

A short, urgent memoir. The first half is about an ordinary childhood.
The second half is entirely about doors — which ones to avoid, the sounds
they make, how to tell if something is on the other side waiting for you
to go first. The last chapter ends mid-sentence.
EOF

cat > "living_room/bookcase/A_Brief_History_of_Screaming.txt" << 'EOF'
Author: Prof. L. Loudly, Dept. of Acoustic Anthropology

An academic survey covering 40,000 years of recorded human screaming.
Chapter 12 analyses screaming in isolated manor houses specifically —
echo patterns, resonance frequencies, duration averages.
You put this one back quickly.
EOF

cat > "living_room/bookcase/Advanced_Lockpicking_for_Beginners.txt" << 'EOF'
Author: Anonymous

The title is deliberately contradictory and the author knows it.
Two chapters are in a cipher that has never been decoded.
The practice lock included with the original copy is long gone.
A handwritten note inside says simply: "it worked."
EOF

cat > "living_room/bookcase/Whats_That_Sound-Field_Notes.txt" << 'EOF'
Author: W. Fright

A researcher's journal documenting sounds recorded in this specific manor
over 18 months. Early entries are methodical: timestamps, diagrams, analysis.
By month 14, the entries only describe the silence between sounds.
Month 17 is a single line: "it is not the house making the sounds."
The author did not publish a follow-up.
EOF

cat > "living_room/bookcase/The_Etiquette_of_Trespassing.txt" << 'EOF'
Author: Lady V. Trespass

A leather-bound etiquette guide for entering properties uninvited.
Chapter 5: "What to Do When the House Notices You."
Chapter 7: "Graceful Exits." It is the shortest chapter in the book.
EOF

cat > "living_room/bookcase/Crows-Omen_or_Just_Birds.txt" << 'EOF'
Author: Dr. R. Harbinger
Subtitle: They Are Omens.

A study that begins as objective ornithology and gradually abandons
all scientific neutrality. The author's final conclusion, printed in bold:
"At this point I have given up arguing. The crows know something.
They have always known."
EOF

cat > "living_room/bookcase/You_Should_Leave-A_Novel.txt" << 'EOF'
Author: Unknown

A slim novel. Minimalist cover: just the title, very large, on white.
No author name. No description.
First sentence: "You should leave."
Second sentence: "You are still here."

The remaining pages are blank.
EOF

cat > "living_room/bookcase/Sleep_Disorders_of_the_Recently_Deceased.txt" << 'EOF'
Author: Dr. M. Pallor, Sleep Research Institute

A clinical reference that starts as conventional medicine and, by chapter 4,
has abandoned all standard diagnostic criteria. Includes the chapter:
"When Your Patient Is Not Technically Awake But Also Not Technically Asleep."
Margin note on the last page: "see also: this house."
EOF

# ── ACTION: .open_secret_room.sh  (HIDDEN FILE) ───────────────
cat > "living_room/bookcase/.open_secret_room.sh" << 'EOF'
#!/usr/bin/env bash
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: ./.open_secret_room.sh"
    echo ""
    echo "Activates the hidden mechanism behind the bookcase."
    echo "Slides it aside to reveal a secret room in the living room."
    exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIVING_ROOM="$(dirname "$SCRIPT_DIR")"

echo ""
echo "You run your fingers along the spines. One book — 'You Should Leave'"
echo "— doesn't quite feel like the others."
sleep 0.6
echo ""
echo "You pull it."
sleep 0.8
echo "Nothing happens."
sleep 0.4
echo "You pull harder."
sleep 0.5
echo ""
echo "A deep mechanical click resonates from inside the wall."
sleep 0.8
echo "The bookcase shudders."
sleep 0.4
echo "Then — slowly — it begins to slide aside, releasing a rush of cold air"
echo "from the darkness behind it."
sleep 0.8
echo ""
echo "A new door has appeared in the living room."
echo ""

cp -r "$LIVING_ROOM/.staging/secret_room" "$LIVING_ROOM/secret_room"
EOF
chmod +x "living_room/bookcase/.open_secret_room.sh"

# ================================================================
# STAGING DIRECTORIES
# (pre-built content, copied into place when triggered by scripts)
# ================================================================

# ── Staging: kitchen pantry ───────────────────────────────────
mkdir -p kitchen/.staging/pantry

cat > kitchen/.staging/pantry/cobwebbed_flour.txt << 'EOF'
A large sack of flour mummified in cobwebs.
"Best Before: 1987" is stamped on the side in cheerful font.
The sack has hardened into a solid mass. It will never be flour again.
EOF

cat > kitchen/.staging/pantry/mystery_tin.txt << 'EOF'
An unlabeled tin can, its paper wrapper long since decomposed.
Something shifts inside when you tilt it.
The lid has been opened once, and carefully pressed back down.
You leave it exactly as you found it.
EOF

cat > kitchen/.staging/pantry/black_jam.txt << 'EOF'
A jar of preserves so old its contents have turned completely, uniformly black.
The label reads "Strawberry — Summer '89" in cheerful cursive.

It is not strawberry.
EOF

cat > kitchen/.staging/pantry/stale_crackers.txt << 'EOF'
A sleeve of crackers nibbled at by at least three generations of rodents.
The crackers themselves have achieved a kind of geological stability —
they will outlast the manor, and probably you.
EOF

cat > kitchen/.staging/pantry/power_cell_1 << 'EOF'
A cylindrical power cell, roughly the size of a thermos.
It pulses with a faint, steady blue glow — impossibly modern
against the decay surrounding it.

This goes in the door_generator in the lobby.
EOF

# ── Staging: secret room ──────────────────────────────────────
mkdir -p living_room/.staging/secret_room

cat > living_room/.staging/secret_room/power_cell_2 << 'EOF'
A cylindrical power cell, pulsing with faint blue light.
It was placed here deliberately — hidden behind the bookcase,
waiting for someone who knew to look carefully.

This goes in the door_generator in the lobby.
EOF

cat > living_room/.staging/secret_room/note.txt << 'EOF'
A single card placed on a small stand in the centre of the room —
left here deliberately, as if anticipated.

    "If you found this, you know how to look.
     Two down. One more to go.

     The last cell is locked up tight.
     The guest left a number. The master has the safe."

                                               — W
EOF

# ── Staging: street ───────────────────────────────────────────
mkdir -p .staging/street

cat > .staging/street/README.txt << 'EOF'
You're outside.

Cold night air fills your lungs. Above you, a full moon.
Behind you, the manor — its windows dark, its crows finally silent.

The street stretches out ahead.
EOF

cat > .staging/street/run_away.sh << 'OUTEREOF'
#!/usr/bin/env bash
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: ./run_away.sh"
    echo ""
    echo "You made it out. Run!"
    echo "Press Ctrl+C to exit."
    exit 0
fi

trap 'tput cnorm; clear; echo ""; exit 0' INT
tput civis
clear

COLS=$(tput cols 2>/dev/null || echo 80)
ROWS=$(tput lines 2>/dev/null || echo 24)
MID=$(( ROWS / 2 - 5 ))

# ── Indiana Jones — 4 running frames, 10 lines × 22 chars ─────
# Hat: wide-brimmed fedora. Whip: trailing to the left.
declare -a F0=(
'      ,--------,      '
'   __/  ,~~~~,  \__   '
'  /    ( o  o )    \  '
'   \    \____/    /   '
'    \____/ || \___/   '
'   ~~~~~  /||\        '
'         / || \       '
'        /  /\  \      '
'       /  /  \  \     '
'      |  |    |  |    '
)
declare -a F1=(
'      ,--------,      '
'   __/  ,~~~~,  \__   '
'  /    ( o  o )    \  '
'   \    \____/    /   '
'    \____/ || \___/   '
'   ~~~~~  /||\        '
'         / || \       '
'        /\ /   \      '
'       /  X     |     '
'      |  / \    |     '
)
declare -a F2=(
'      ,--------,      '
'   __/  ,~~~~,  \__   '
'  /    ( o  o )    \  '
'   \    \____/    /   '
'    \____/ || \___/   '
'   ~~~~~  /||\        '
'         / || \       '
'            ||        '
'           /  \       '
'          /    \      '
)
declare -a F3=(
'      ,--------,      '
'   __/  ,~~~~,  \__   '
'  /    ( o  o )    \  '
'   \    \____/    /   '
'    \____/ || \___/   '
'   ~~~~~  /||\        '
'         / || \       '
'        /    /\       '
'       |    /  \      '
'       |   |    |     '
)

frames=(F0 F1 F2 F3)
fi=0
x=1
max_x=$(( COLS - 23 ))

while true; do
    clear
    ref="${frames[$fi]}[@]"
    lines=("${!ref}")
    for i in "${!lines[@]}"; do
        tput cup $(( MID + i )) $x
        printf '%s' "${lines[$i]}"
    done

    fi=$(( (fi + 1) % 4 ))
    x=$(( x + 2 ))

    if [ "$x" -ge "$max_x" ]; then
        sleep 0.3
        clear
        printf '\033[1;33m'
        tput cup $(( ROWS/2 - 4 )) 0
        cat << 'ART'

  __   __ ___  _   _   ___  ____   ___   _   ____  ___  ____  _
  \ \ / // _ \| | | | | __|/ ___| / __\ / \ |  _ \| __||  _ \| |
   \ V /| (_) | |_| | | _| \___ \| (__ / _ \| |_) | _| | | | |_|
    \_/  \___/ \___/  |___|/____/ \___/_/ \_\____/|___||_| |_(_)

ART
        printf '\033[0m'
        tput cup $(( ROWS/2 + 2 )) 0
        printf '%*s\n' $(( (COLS + 22) / 2 )) "Press Ctrl+C to close"
        while true; do sleep 10; done
    fi

    sleep 0.09
done
OUTEREOF
# chmod set by open_door.sh after copy

# ================================================================
# VISUAL PADDING — add breathing room above/below all object text
# ================================================================
find . -name "*.txt" | while IFS= read -r f; do
    { printf '\n\n'; cat "$f"; printf '\n\n'; } > "${f}.tmp" && mv "${f}.tmp" "$f"
done

# ================================================================
# DONE
# ================================================================
cd ..
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║    Manor Escape — setup complete!  🏚️         ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "To start the game:"
echo "  cd manor"
echo "  cat README.txt"
echo ""
