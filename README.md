# Drupalazy

Need to upgrade from Drupal 9 to Drupal 10 with a lot of modules or custom themes?

Are you afraid of having to modify all your `.info.yml` files by hand to add a crummy '^10'?

Can't find any module or tools to do it?

Need a simple and quick trick to avoid this chore?

Here is **Drupalazy**: the Drupal tool for ~~lazy~~ productive people!

## How to use it?
### The fastest way
- Open a terminal
- Navigate to your Drupal installation path
- Execute the following command : `bash <(curl -s https://raw.githubusercontent.com/johnatas-x/drupalazy/main/drupalazy.sh)`
- Press enter on the first question

### Alternative way
If you don't trust a bearded man, you can download the `drupalazy.sh` file locally, proofread it, adapt it, give it execution rights and run it.
## How it works?
When you run the script, a prompt appears and asks you for the Drupal installation path. By default, the current directory is pre-entered. You can, if necessary, modify or validate it.

If the path entered is incorrect, an error appears and gives you a second chance!
<sub>Tips : The Drupal installation path contains the 'modules' and 'themes' folders.</sub>

If the path is correct, the update begins.

The script processes the modules first and then the themes (in alphabetical order).

This is where the magic happens (finally, this is where Sed replaces `^9` with `^9 || ^10`).

Three possible cases :
- If the update worked, a nice little green check is added next to the file name.
- If the file is already Drupal 10 compatible, it is skipped and a nice little yellow check is added next to the file name.
- If the update failed, a ugly red cross is added next to the file name.

If you're a summary fanatic, there's one at the end of the script (and in addition, there is even a summary of the files in error)!

Enjoy your coffee,

Johnatas
