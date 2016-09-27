#COLORIZE SHELL

Writing a bash script? want sexy colors to make reading and debugging easier? then....

### Installation
1. Simply `source .bashColors.sh` in one of your topmost files, usually along with environment or global variables.
2. Like those stupid color runs, colorize the F*$% outta EVERYTHING. Go nuts.
3. ????
4. Profit!

## CAVEAT
This shell script does not define specific hex colors. It defines color codes that are interpreted from your current terminal's ANSI color codes in the active color scheme. Your mileage may vary as to what colors appear. If you cant see stuff, check iterm2 color profiles to see what color scheme you have set. Chances are, you have one of the colors set to a color that isn't visible on your terminal.


### Usage

Supported Colors:
  1. RED
  2. GREEN
  3. YELLOW
  4. BLUE
  5. PURPLE
  6. CYAN
  7. WHITE
  8. GRAY

Background colors are not supported, but could be easily. Fork if you want them.

# Methods

## separator
Very simple method that prints a divider line as wide as the terminal window with whatever character you input into the function.  

Params:
  1. delimiter - a character to use as a delimiter. Defaults to '-'.


## echoColorText
Generic method that allows you to pass a string, a prefix string, and  

Params:
  1. text (string) - any string. Can be filled with other colors as well to delimit certain parts of text.
  2. prefix (string) - any string. Should be used to define what type of message is being sent through.
  3. color (var) - added as a variable. e.g. `$RED`

Examples:  
` "Hello World. This is ${YELLOW}BASH COLORING${NOCOLOR}." "MSG: " $BLUE `


# Specific methods:
These methods are preset to accept a message string, and use specific prefixes and colors. self explanatory really.

## successMsg
Uses green and the "Success:" prefix. Use for success messages. duh.

## errorMsg
For all your homer simpson "d'oh" moments, use this. Defaults to red text.

## warningMsg
The equivalent of a finger wag in dev world. Uses purple.

## noticeMsg
A "hey, so this is happening" message. Is Blue.

## infoMsg
FYI. Yellow.
