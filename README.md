This is a very simple addon to keep track of VAS miniboss' HP, to help raid leaders with callouts. Because Felms and Llothis don't count as bosses, their HP doesnt display as a static panel, and you need to target them to see their HP. This addon simply keeps track of the last HP % of the 2 bosses, and updates them whenever you target them.

I was getting frustrated having to ask people for miniboss HP at times, so this addon should let you track approximate health percentages of the minibosses. Especially, if you are the offtank, you don't need to worry about having to target the minibosses to know their percentages.

The numbers go out of date the longer you are not targeting your target, but in a dynamic fight like VAS, that should be a very rare scenario.
The panel currently starts off in the center of the screen, so you'll have to manually move it. The position is also not saved right now. More features to come soon.
The panel will automatically show up when you enter VAS.

There are a few slash commands.

/vasdebug on or /vasdebug true turns on debug information in your chat box. Any other argument will turn debugging off. Debugging is turned off by default.
/vason explicitly shows the panel.
/vasoff explicitly hides the panel.

/track [unitname] is mainly for testing purposes. You can enter the name of any mob here (like /track Spider), and it will track that mob's health percentage. The string can be a substring of the actual mob name, so /track Midnight will track a mob called "Midnight Union Sentry".

Comments and suggestions welcome.