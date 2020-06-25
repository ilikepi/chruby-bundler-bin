# chruby-bundler-bin

Plugin for [chruby](https://github.com/postmodern/chruby) for automatically
adding Bundler.bin_path to `PATH`.

The primary goal of this script is to add each entry in Bundler.bin_path entry
to `$PATH` after chruby is automatically executed.

## Installation

In whatever shell initialization file you've loaded chruby and its own auto.sh
file, add the following lines:

### For bash

    ```sh
    # required work-around for limitation of trap command
    trap - DEBUG

    source path/to/chruby-bundler-bin/auto.sh
    ```

### For zsh

    ```sh
    source path/to/chruby-bundler-bin/auto.sh
    ```

## Known issues

* The trap command work-around noted in the bash installation instructions.
* Code and documentation quality are lacking.

## Copyright

This software is copyright 2020 James Blanding and is made available
under the MIT License.  See LICENSE.txt for details.
