# Drupalazy
## Table of contents
- [Prerequisite](#memo-prerequisite)
- [What is this stuff?](#scream-what-is-this-stuff)
- [How to use it?](#anguished-how-to-use-it)
- [How it works?](#construction-how-it-works)
- [Creator and license](#bear-creator-and-license)

## :memo: Prerequisite
- Drupal >= 8
- Custom modules inside the directory `modules/custom` and compatibles with your current Drupal's version
- Custom themes inside the directory `themes/custom` and compatibles with your current Drupal's version
- Custom profiles inside the directory `profiles/custom` and compatibles with your current Drupal's version

If your paths are not `%/custom`, please download & adapt script locally.

## :scream: What is this stuff?

Need to upgrade from Drupal 8, 9 or 10 to Drupal 9, 10 or 11 with a lot of custom modules, themes or profiles?

Are you afraid of having to modify all your `.info.yml` files by hand to add a crummy '^9', '^10' or '^11''?

Can't find any module or tools to do it?

Need a simple and quick trick to avoid this chore?

Here is **Drupalazy**: the Drupal tool for ~~lazy~~ productive people!

### Ahead of time?
This tool has no limits. You can therefore move from Drupal 8 compatibility to Drupal 42 compatibility.

## :anguished: How to use it?
### The fastest way
- Open a terminal
- Navigate to your Drupal installation path
- Execute the following command : `bash <(curl -s https://raw.githubusercontent.com/johnatas-x/drupalazy/main/drupalazy.sh)`
- Press enter on the first question
- Press enter on the second question (or update the target version)

### Alternative way
If you don't trust a bearded man, you can download the `drupalazy.sh` file locally (or clone this project), proofread it, adapt it, give it execution rights and run it.

## :construction: How it works?
When you run the script, a prompt appears and asks you for the Drupal installation path. By default, the current directory is pre-entered. You can, if necessary, modify or validate it.

If the path entered is incorrect, an error appears and gives you a second chance!
<sub>Tips : The Drupal installation path contains the 'core', 'modules' and 'themes' folders.</sub>

If the path is correct, the update begins.

The script processes the modules first, then the themes and finally the profiles (in alphabetical order).

This is where the magic happens (finally, this is where Sed replaces `^N` with `^N || ^N+n`).

Three possible cases :
- If the update worked, a nice little green check is added next to the file name.
- If the file is already compatible with the target version, it is skipped and a nice little yellow check is added next to the file name.
- If the update failed, an ugly red cross is added next to the file name.

If you're a summary fanatic, there's one at the end of the script (and in addition, there is even a summary of the files in error)!

## :bear: Creator and license
Created by [Johnatas](https://github.com/johnatas-x).

Please share the original open source tool and not a copy.

Feel free to suggest improvements.

Enjoy 🍻

Johnatas
