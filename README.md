# Drupalazy
## Table of contents
- [What is this stuff?](#scream-what-is-this-stuff)
- [How to use it?](#anguished-how-to-use-it)
- [How it works?](#construction-how-it-works)
- [Creator and license](#bear-creator-and-license)

## :scream: What is this stuff?

Need to upgrade from Drupal 9 to Drupal 10 with a lot of modules or custom themes?

Are you afraid of having to modify all your `.info.yml` files by hand to add a crummy '^10'?

Can't find any module or tools to do it?

Need a simple and quick trick to avoid this chore?

Here is **Drupalazy**: the Drupal tool for ~~lazy~~ productive people!

### Ahead of (or behind) time?
Don't panic ! This tool also allows the upgrade from version 8 to 9.

This tool is also already ready for an upgrade from 10 to 11.

## :anguished: How to use it?
### The fastest way
- Open a terminal
- Navigate to your Drupal installation path
- Execute the following command : `bash <(curl -s https://raw.githubusercontent.com/johnatas-x/drupalazy/main/drupalazy.sh)`
- Press enter on the first question

### Alternative way
If you don't trust a bearded man, you can download the `drupalazy.sh` file locally (or clone this project), proofread it, adapt it, give it execution rights and run it.

## :construction: How it works?
When you run the script, a prompt appears and asks you for the Drupal installation path. By default, the current directory is pre-entered. You can, if necessary, modify or validate it.

If the path entered is incorrect, an error appears and gives you a second chance!
<sub>Tips : The Drupal installation path contains the 'core', 'modules' and 'themes' folders.</sub>

If the path is correct, the update begins.

The script processes the modules first and then the themes (in alphabetical order).

This is where the magic happens (finally, this is where Sed replaces `^9` with `^9 || ^10`).
- If your current Drupal version is 8.x, the files will be updated to `^8 || ^9`.
- If your current Drupal version is 10.x, the files will be updated to `^10 || ^11`.

Three possible cases :
- If the update worked, a nice little green check is added next to the file name.
- If the file is already Drupal 10 (or 9 or 11) compatible, it is skipped and a nice little yellow check is added next to the file name.
- If the update failed, a ugly red cross is added next to the file name.

If you're a summary fanatic, there's one at the end of the script (and in addition, there is even a summary of the files in error)!

## :bear: Creator and license
Created by [Johnatas](https://github.com/johnatas-x).

Please share the original open source tool and not a copy.

Feel free to suggest improvements.

Enjoy 🍻

Johnatas
