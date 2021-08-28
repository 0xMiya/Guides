# Neovim

## Operations

An operation is usually build like this:

Operator | [Count] | Motion
:------- | :-----: | -----:
j        | 2       | w

Operator
:	The action to execute
:	j, delete

Motion
:	The element that the Operator will operate on
:	w, word

Count (Optional)
:	Number of elements (motions) to operate on
:	2, operate on two motions

### Motions

Motion | Description
:----- | :----------
w      | go forward to the start of word
e      | go forward to the end of word
b      | go backward to the start of word

## Keybindings

I use Dvorak, so some keys may seem to be a little bit weird...

I've rebound my <kbd>Capslock</kbd> key to be <kbd>ESC</kbd> instead, which is
done at OS level, not in my nvim-config.

`<C-x>`	means the Control-key (in this document just written as `Ctrl` and x.\
`<S-x>` means the Shift-key and x (in this document just written as the capital
letter `X`).

### Normal Mode

Key  | Function
:--- | :-------
F1   | Open help
h    | Move cursor down
t    | Move cursor up
d    | Move cursor left
n    | Move cursor right
H    | Move 12 lines down
T    | Move 12 lines up
x    | Delete character
i    | [Insert](#Insert-Mode) text (insert before cursor)
a    | [Append](#Insert-Mode) text (insert after cursor)
I    | [Insert](#Insert-Mode) text at start of line
A    | [Append](#Insert-Mode) text at end of line
o    | [Insert](#Insert-Mode) text below current line
O    | [Insert](#Insert-Mode) text above current line
:, <kbd>ESC</kbd> | Enter [Command Mode](#Command-Mode)
jj   | Delete current line
w    | Jump forward to the start of a word
e    | Jump forward to the end of a word
b    | Jump backward to the start of a word
jw   | Delete until start of next word
je   | Delete until end of current word
jb   | Delete until start of current word
(    | Jump sentence backward
)    | Jump sentence forward
{    | Jump paragraph backward
}    | Jump paragraph forward
0    | Jump to start of line
\_, ^| Jump to start of line excluding whitespaces
\$, - | Jump to end of line
j$, j- | Delete until end of line
j^, j_ | Delete until start of line excluding whitespaces
j0   | Delete until start of line
u    | Undo
U    | Undo all changes of current line
Ctrl-r | Redo
p    | Paste _after_ cursor (Nvim should use the same clipboard as the os)
yy   | Copy current line
y(motion) | Copy motion
r(x) | Replace with _x_
R    | Enter Replace Mode (Allows to overwrite following text)
c(motion) | Change (deletes motion and enters [Insert Mode](#Insert-Mode))
ce   | Change untill end of word
cc   | Change whole line
Ctrl-g | Show `position` and `filename`
G    | Move to bottom of file
gg   | Move to top of file
(line number)G | Move to line number
/(search term)-Enter | Forward search
/(search term)\\c | Ignore case for this search
\*   | Forwardsearch for word under cursor
g\*   | Include matches that are not a whole word
?(search term)-Enter | Backward search
\#   | Backwardsearch for word under cursor
g#   | Include matches that are not a whole word
l    | Jump to next result
L    | Jump to previous result
%    | Jump to matching parentheses `(`,`[`,`{`,`}`,`]`,`)`
Ctrl-o | Go back where you came from (jump history)
Ctrl-i | Go forward again (jump history)
~    | Change (upper/lower) -case of current character
V    | [Select](#Visual-Mode) current line
v    | Enter [Visual Mode](#Visual-Mode)
v-(motion)-:w \<file> | Save selected text to `file`
J    | Concatenate lines (with a single space between)
\>>  | Indent line to the right (add indentation)
`<<` | Indent line to the left (remove indentation)
xpd  | Cut, Paste, Move cursor left (Replace two characters)
zz   | Center screen
==   | Indent current line
m', m\` | Set mark
'', \`\` | Jump to mark
gx   | Open link under cursor in a webbrowser
f\<motion> | Jump forward to `motion`. The cursor is placed onto the motion.
f"   | Jump forward to next double quote.
k(motion) | Jump forward to `motion`. The cursor is placed before the motion.
Ctrl-a | Increment current (or next) number
Ctrl-x | Decrement current (or next) number

#### Pane Movement

Key  | Description
:--- | :----------
~~N~~  | ~~Select next pane~~
Ctrl-h | Select pane below
Ctrl-t | Select pane above
Ctrl-d | Select pane left
Ctrl-n | Select pane right
Ctrl-w x | Switch position of current pane with position of last active pane

#### Tab Movement

Key  | Description
:--- | :----------
gt   | Go to next tab
gT   | Go to previous tab
(n)gt | Go to nth tab
g<kbd>Tab</kbd> | Go to last accessed tab
:tabnew {file} / :tabe[dit] {file} | Open new tab
:tabc[lose] | Close tab
:tabo[nly] | Close all tabs except current
:tabs | List all tabs and their windows
:tabm[ove] (n) | Move tab to nth position

### Insert Mode

Key  | Function
:--- | :-------
Ctrl-h | Move current line down
Ctrl-t | Move current line up
Ctrl-x s | (When `set spell`) Display auto correction
Ctrl-n | Select next element in completion-menu
Ctrl-p | Select previous element in completion-menu

### Visual Mode

Key  | Function
:--- | :-------
j    | Delete selected text
y    | Copy (yank) selected text
~    | Change (upper/lower) -case
U    | To upper case
u    | To lower case
H    | Move selected lines down
T    | Move selected lines up
gq   | Format lines (fixes indentation)
=    | Indent selection

#### Visual Block Mode

Enter by pressing <kbd>Ctrl-v</kbd>

### Command Mode

Use <kbd>Tab</kbd> for autocomplete.

Command | Function
:------ | :-------
:h, help (keyword) | Open help for "keyword"
:!\<command> | Execute external shell _command_
:w      | Write (Save)
:q      | Quit
:q!     | Quit without saving
:wq     | Save and quit
:e \<path> | Open _path_
:\<line number> | Jump to line number
:s/find/replace/ | find-replace for only first occurence
:s/find/replace/g | find-replace for all occurences on current line
:`'<,'>`s/find/replace/g | find-replace for selection (Enter [Visual Mode](#Visual-Mode), select text, press `:`)
:`#,#`s/find/replace/g | find-replace between line `#` and line `#`
:%s/find/replace/g | find-replace in the whole file
:%s/find/replace/g<strong>c</strong> | Ask for confirmation on each result
:r \<file>  | Insert text from another `file` below cursor
:r !ls      | This also works with commands
:set ic  | Set search to case <strong>in</strong>sensitive
:set noic| Set search to case sensitive (no = off)
:set invic | Toggle search case (in)sensitive (inv = invert)
:set hls | Highlight ??? matching words
:noh    | Stop highlighting words after search

### Leader

The \<leader> key is set to <kbd>,</kbd> (comma).

Key     | Description
:------ | :----------
,nh     | Stop highlighting words after search
,h      | Move current line down
,t      | Move current line up
,m      | Toggle quickfix menu
,a      | Add file to quickfix-list
,n      | Toggle NERDTree
,ff     | Telescope find files
,fb     | Telescope buffers

### Terminal Mode

Key  | Description
:--- | :----------
ESC  | Leave terminal mode

### Advanced

#### Inside & Around

> NOTE: Even though I wrote "current \<motion>", with quotes this will also
> work for the next motion, if you are outside of the specified motion.

Key  | Description
:--- | :----------
i    | inside
a    | around
ji\<motion> | Delete inside of `motion`.
ji{  | Delete everything inbetween current braces.
ja\<motion> | Delete around `motion`.
ja{  | Delete everything inside and including current braces.
ci{  | Change (puts you in insert mode) everything inside current braces.
ci"  | Change (puts you in insert mode) everything inside current double quotes.
vi{  | Highlight everything inside current braces.
=i{  | Fix indentation between current braces.
ji(  | Delete everything inbetween current parentheses.
ji'  | Delete everything inbetween current single quotes.
yi(  | Copy (yank) everything inbetween current parentheses.
f\<motion> | Jump forward to `motion`
f"   | Jump forward to next double quote.
gi   | Go to last insert location and switch to [Insert Mode](#Insert-Mode)
viw  | Highlight current word (visual - inside - word)

#### The G-Spot ;-)

Key  | Description
:--- | :----------
Ctrl-G | Show information about current cursor position.
g8   | Get UTF-8 code of symbol under cursor.
g<   | Reopen output of last command.
g&   | Replay last "s"-command (find command)
gJ   | Concatenate lines whithout inserting a space.
gU(motion) | Set `motion` to uppercase.
gUiw | Set current word to uppercase (g - uppercase - inside - word).
gUk<kbd>space</kbd> | Set everything until next space to uppercase.
gd   | Jump to local definition.
gD   | Jump to global definition.
<kbd>space</kbd>gd | (coc only) Jump to actual definition.
gf   | Jump to file (-name under cursor). (README.md)
gF   | Jump to file on line under cursor. (README.md:10)
gq   | [(Visual Mode)](#Visual-Mode) Format selected text.
(number)g_ | Jump down number-1 lines and put cursor to the end of the line.
g$, g_ | When `set wrap`, jump to the end of the current part of the wrapped line.
g??  | Rot-13 on the whole line.
g?   | Rot-13 on selected text.
gg   | To the top!
G    | To the bottom!
(number)G | Jump to line number.
gv   | Rehighlight last visual area.
gi   | Go to last insert location and switch to [Insert Mode](#Insert-Mode)
:'\<,'\>g/find/(action) | Execute action over find results.
:g/find/d | Search for `find` and `d` (delete) it. (Note that your keybindings won't work here.)
:g/find/norm! (action) | Execute any command (action) you want.

### Macros

1. Start recording by pressing <kbd>q</kbd> and a char, e.g. <kbd>a</kbd>.
2. Do whatever you want to do.
3. Stop recording by pressing <kbd>q</kbd>.
4. Replay the macro by pressing <kbd>@</kbd> and the same char (e.g. <kbd>a</kbd>).

### Plugin specific

#### completion-nvim

Key  | Description
:--- | :----------
<kbd>Tab</kbd> | Navigate through popup menu
<kbd>Shift-Tab</kbd> | Navigate through popup menu oppsite direction
Ctrl-p | Trigger completion menu

#### Harpoon

Key  | Description
:--- | :----------
\<leader>m | Toggle quickfix menu
\<leader>a | Add file to quickfix-list

#### NERDTree

General

Key  | Description
:--- | :----------
N | Toggle NERDTree
F | NERDTreeFind (show current file in NERDTree)

Inside of NERDTree

Key  | Description
:--- | :----------
Enter|  Open file (replaces previous file)
s    | Open file in vertical split
i    | Open file in horizontal split
o    | Open in previous window
go   | Open in preview (don't focus the opened file)
v    | Open in new tab
T    | Open in new tab without switching to it

On a node (directory)

Key  | Description
:--- | :----------
o, <kbd>Enter</kbd> | Expand directory
O    | Expand diretory and subdirectories recursively
v, T | Open dir in new tab, silently
x, X | Close dir, recursively
e    | Explore dir (look at it in a new panel)

Filesystem

Key  | Description
:--- | :----------
n    | Change root to selected directory
d    | Move tree root up a dir
U    | Move tree root up but leave old root open (expanded)
r    | Refresh dir under cursor
R    | Refresh root dir
A    | Zoom (maximize-minimize NERDTree window)
m    | Show menu
I    | Toggle hidden files
B    | Toggle bookmarks

Tree navigation

Key  | Description
:--- | :----------
P    | go to root
p    | go to parent
K    | go to first child
J    | go to last child
Ctrl-j, -k | go to next, previous sibling (file in directory)

Bookmarks

Key  | Description
:--- | :----------
:Bookmark | Bookmark directory under cursor
D    | Remove bookmark under cursor
B    | Toggle bookmarks

#### Telescope

Key  | Description
:--- | :----------
\<leader>ff | Telescope find files
\<leader>fb | Telescope buffers

#### Fugitive

Key  | Description
:--- | :----------
:G   | Open fugitive
s    | add (stage)
u    | reset (unstage)
\-   | add/reset (stage/unstage)
U    | reset (unstage) everything
X    | Discard change. (uses checkout or clean)
2X   | checkout --ours (merge conflict)
3X   | checkout --theirs (merge conflict)
=    | Toggle inline diff
\>   | Insert inline diff
`<`  | Remove inline diff
dd   | :Gdiffsplit
dv   | :Gvdiffsplit
ds   | :ghdiffsplit
<kbd>Enter</kbd> | Open file under cursor
o    | Open file in a horizontal split
gO   | Open file in a vertical split
O    | Open file in new tab
cc   | Create commit
ca   | Amend last commit and edit the message
ce   | Amend last commit without editing the message
cw   | Reword the last commit
crc  | Revert commit under cursor
coo  | Checkout commit under cursor
:Gllog | Open git log
