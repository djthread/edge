# Edge

Layout Manager for the Kinesis Freestyle Edge Keyboard

## Why?

The dense lines of code in the `layout1.txt` file as deployed to the keyboard's v-drive is not very readable. Rather than maintain a separate cheat sheet which needs to be maintained in concert with the actual layout file, I wanted a quick tool which allows me to create an annotated file containing my comments side-by-side with the layout code. With this tool, I can edit this "reference" file, and on save, only the lines of code will be written to the keyboard's corresponding layout txt file.

## Usage

With this tool, the `ref.layout1.txt` file, for instance, can intersperse comments with the lines of code.

Example:

    hk3 - max left    {hk3}>{x1}{-lshft}{-lctrl}{lft}{+lshft}{+lctrl}
    hk4 - max right   {hk4}>{x1}{-lshft}{-lctrl}{rght}{+lshft}{+lctrl}

In this example, the bits to the left are my comments, and the bits to the right are the lines of code that will end up in the output layout file.

The `edge` command is to be invoked with a command, followed by any options needed. Example:

    edge install --layout 2

Available commands are:

* `install` - Install a layout (from ref file) to keyboard. Alias is `i`.
* `cheat` - Echo all the comments (cheat sheet) to console. Alias is `c`.

Available options are:

* `--layout` - Specifies the layout to operate on. Short version is `-l`. Default is `1`.

## Installation

Edit the file patterns in `config/config.exs` to match your situation.

Then, simply build the project as an escript:

    mix escript.build

Now, it can be invoked directly. For instance, to install the `ref.layout1.txt` to `layout1.txt`:

    ./edge install --layout 1

To make things even nicer, create an alias similar to one like this (for the fish shell):

    # Edit Keyboard
    alias ek 'vim /path/to/ref.layout1.txt; and /path/to/edge install --layout 1'