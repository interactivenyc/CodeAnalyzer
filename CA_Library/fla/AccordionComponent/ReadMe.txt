AccordionComponent

Based on original code by Ady Levy - adylevy.com
Custom mods for outside created panel objects - Alan Gruskoff - alang@digitalshowcase.biz 03-14-10

These Flash files are used in the Flash authoring tool.
	AccordionExample.fla
	AccordionExample.as

To compile this App, these support files need to live in the same directory as the above files.
	AccordionComponent.as
	caurina (Directory with tweening library)
	PanelSprite.as
	TopLevel.as
	
This version is all ActionScript 3.0, with nothing in the AccordionExample.fla file, except a pointer to the AccordionExample.as file where the code is for building the panels. It uses Sprites in a Horizontal Accordion mode with a Gradient header for each Panel.

The main body of the AccordionExample() function builds 5 panels that the user can customize to need. This style could be used to integrate the AccordionComponent with production code.

To access the Panel content of the Accordion object, do:
	accord.openPanel(1)

where 1 is the number of the Panel within the Accordion object to open.

***








