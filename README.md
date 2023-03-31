# Installation Guide

## Installing GitPromptExtension

 1. Run the Setup.sh like so:
 
    ```bash Setup.sh```

This will install all the necessary components.

You will be able to type:

```gpe```

Or whatever you set the custom command alias to be in the GPE.settings file.

To run the command, type the alias into the terminal.

GPE will persist inside of the Terminal instance once you have ran the command.

If you close the Terminal (CLI) then you will need to run the command again.

## Customisation
There is a file called ```GPE.settings``` which contains settings you can change to customise GPE.

Below is an example of the configurable settings currently available in this version:

```
> Brackets Colour [ ]
Yellow

> Git Branch Name + Status Indicator ≡ ↑ ↓
LightCyan

> Staged Stat Colours +0 ~0 -0
Green

> Unstaged Stat Colours +0 ~0 -0
Red


> Below is the GPE alias
> Feel free to change it to anything you want
gpe
```

The colour settings will automatically take effect even in the live console, however the prompt will require you to run Setup.sh again.

## Important Notes
If you move the Folder which contains the scripts in it to a different directory, run the Setup.sh again to update the path links.


GitPromptExtension will show Git repo information similar to Posh.git and will smart detect if you are in a git repo or not.
