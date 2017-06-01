xkas 0.06.1, unofficially fixed version of xkas, originally by byuu

First, xkas is made by byuu. Full credit should go to him.
I know xkas 0.06 is outdated because the author already made newer versions.
But xkas 0.06 is still a great assembler, so I unofficially updated this version to make it a little better.

what fixed
----------

-PEA opcode

	This version allows you to use labels for this.

-base command

	Branches are broken while "base" is enabled, so fixed this as well.

-MVN / MVP

	You had to specify the operand as word value, like this;

	MVN $127E	; In this case, $12 is a source bank, $7E is a destination bank

	But for those who are familiar with other assembly, this is kind of weird.
	Therefore, I made it so you can use this opcode in this format;

	MVN $7E,$12	; MVN $dest,$src

	This allows you to write your code like this:

	MVN $7E,Table>>16

	org $*somewhere*
	Table:

	In order to keep the compatibility for your old assembly code,
	this version still allows you to use the old MVN/MVP format
