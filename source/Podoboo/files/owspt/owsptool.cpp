#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char * argv[])
{
	char * romname;
	char * spritestxtname;
	char thisLine[256];
	unsigned char rombank[32768];
	int freespace=0;
	if (argc!=1 && argc!=3)
	{
		puts("usage: tool [rom.smc list.txt]");
		return 1;
	}
	if (argc==1)
	{
		romname=(char*)malloc(256);
		printf("Enter rom name: ");
		//gets(romname);
		fgets(romname, 256, stdin);
		romname[strlen(romname) - 1] = '\0';

		spritestxtname=(char*)malloc(256);
		printf("Enter name of the sprite list: ");
		//gets(spritestxtname);
		fgets(spritestxtname, 256, stdin);
		spritestxtname[strlen(spritestxtname) - 1] = '\0';
	}
	if (argc==3)
	{
		romname=argv[1];
		spritestxtname=argv[2];
	}
	FILE * rom=fopen(romname, "rb");
	if (!rom)
	{
		puts("ERROR: ROM not found.");
		return 1;
	}
	fseek(rom, 0, SEEK_END);
	int romsize=ftell(rom);
	if ((romsize%0x8000)!=512)
	{
		puts("ERROR: Not a ROM, or unheadered ROM.");
		return 1;
	}
	fseek(rom, 0x27A57, SEEK_SET);//check if it's installed already
	fread(rombank, 1, 4, rom);
	if (rombank[0]==0x5C)//check for valid value where this one is hijacked
	{
		freespace=rombank[3];
	}
	else
	{
		//not installed already, find a free bank
		fseek(rom, 0x80200, SEEK_SET);//start of expanded area
		int bankID=0x90;
		while (!freespace)
		{
			fread(rombank, 1, 32768, rom);//ignore RATSs, I can't see why any sane man would protect an entire bank full of zeroes
			for (int i=0;i<32768;i++)
			{
				if (rombank[i]) break;
				if (i==32767) freespace=bankID;
			}
			if (feof(rom))
			{
				puts("ERROR: Couldn't find freespace. Please use Lunar Expand and/or save a level in LM.");
				return 1;
			}
			bankID++;
		}
	}
	fclose(rom);
	FILE * originalasm=fopen("owsp.asm", "rt");
	if (!originalasm)
	{
		puts("ERROR: Couldn't find owsp.asm");
		return 1;
	}
	FILE * tmpasm=fopen("tmpasm.asm", "wt");
	bool foundCodesLine=false;
	bool foundFreespLine=false;
	bool foundWarnpcLine=false;
	bool foundPtrsLine=false;
	bool foundActiveLine=false;
	while (!feof(originalasm))
	{
		fgets(thisLine, 250, originalasm);
		int tmp=strlen(thisLine)-1;
		if (thisLine[tmp]=='\n') thisLine[tmp]=0;
		if (!strcmp(thisLine, ";TOOL LINE: freespace"))
		{
			if (foundFreespLine)
			{
				puts("ERROR: Two freespace tool lines detected");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			foundFreespLine=true;
			fprintf(tmpasm, "org $%.2X8000\n", freespace);
		}
		else if (!strcmp(thisLine, ";TOOL LINE: pointers"))
		{
			if (!foundFreespLine)
			{
				puts("ERROR: The pointers tool line must be after the freespace tool line");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			if (foundPtrsLine)
			{
				puts("ERROR: Two pointers tool lines detected");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			foundPtrsLine=true;
			FILE * spritestxt=fopen(spritestxtname, "rt");
			if (!spritestxt)
			{
				puts("ERROR: Couldn't open sprite list");
				return 1;
			}
			int thisIndex=10;
			while (!feof(spritestxt))
			{
				fgets(thisLine, 250, spritestxt);
				if ((thisLine[2]!=' ' && thisLine[2]!='\t') || (thisLine[10]!=' ' && thisLine[10]!='\t'))
				{
					printf("ERROR: The following line in sprites.txt contains invalid syntax: %s\n", thisLine);
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				int newIndex;
				sscanf(thisLine, "%x", &newIndex);
				if (newIndex<=0 || newIndex>0x8A)
				{
					puts("ERROR: Invalid OW sprite ID");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				if (newIndex<=10)
				{
					puts("ERROR: Sprites 0 through A are used by SMW and can't be changed with this tool");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				if (newIndex<=thisIndex)
				{
					puts("ERROR: sprites.txt must have the sprite with the lowest number first");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				while (newIndex!=thisIndex+1)
				{
					fprintf(tmpasm, "dw $0000;nonexistent sprite\n");
					thisIndex++;
				}
				if (thisLine[11]=='D' && thisLine[12]=='U' && thisLine[13]=='P' && thisLine[14]=='E' && thisLine[15]==':')
					fprintf(tmpasm, "dw owsp%s_Main\n", thisLine+16);
				else fprintf(tmpasm, "dw owsp%.2X_Main\n", newIndex);
				thisIndex++;
			}
			fclose(spritestxt);
		}
		else if (!strcmp(thisLine, ";TOOL LINE: codes"))
		{
			if (!foundFreespLine)
			{
				puts("ERROR: The codes tool line must be after the freespace tool line");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			if (foundCodesLine)
			{
				puts("ERROR: Two codes tool lines detected");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			foundCodesLine=true;
			FILE * spritestxt=fopen(spritestxtname, "rt");
			if (!spritestxt)
			{
				puts("ERROR: Couldn't open sprite list");
				return 1;
			}
			int thisIndex=10;
			while (!feof(spritestxt))
			{
				fgets(thisLine, 250, spritestxt);
				if ((thisLine[2]!=' ' && thisLine[2]!='\t') || (thisLine[10]!=' ' && thisLine[10]!='\t'))
				{
					printf("ERROR: The following line in sprites.txt contains invalid syntax: %s\n", thisLine);
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				int newIndex;
				sscanf(thisLine, "%x", &newIndex);
				if (newIndex<=0 || newIndex>0x8A)
				{
					puts("ERROR: Invalid OW sprite ID");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				if (newIndex<=10)
				{
					puts("ERROR: Sprites 1 through A are used by SMW and can't be changed with this tool");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				if (newIndex<=thisIndex)
				{
					puts("ERROR: sprites.txt must have the sprite with the lowest number first");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				thisIndex=newIndex;
				if (thisLine[11]!='D' || thisLine[12]!='U' || thisLine[13]!='P' || thisLine[14]!='E' || thisLine[15]!=':')
				{
					fprintf(tmpasm, "namespace \"owsp%.2X\"\n", newIndex);
					fprintf(tmpasm, "incsrc %s\n", thisLine+11);
				}
			}
			fclose(spritestxt);
		}
		else if (!strcmp(thisLine, ";TOOL LINE: activation"))
		{
			if (!foundFreespLine)
			{
				puts("ERROR: The activation tool line must be after the freespace tool line");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			if (foundActiveLine)
			{
				puts("ERROR: Two activation tool lines detected");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			foundActiveLine=true;
			FILE * spritestxt=fopen(spritestxtname, "rt");
			if (!spritestxt)
			{
				puts("ERROR: Couldn't open sprite list");
				return 1;
			}
			int thisIndex=10;
			while (!feof(spritestxt))
			{
				fgets(thisLine, 250, spritestxt);
				if ((thisLine[2]!=' ' && thisLine[2]!='\t') || (thisLine[10]!=' ' && thisLine[10]!='\t'))
				{
					printf("ERROR: The following line in sprites.txt contains invalid syntax: %s\n", thisLine);
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				thisLine[10]=0;
				int newIndex;
				sscanf(thisLine, "%x", &newIndex);
				if (newIndex<=0 || newIndex>0x8A)
				{
					puts("ERROR: Invalid OW sprite ID");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				if (newIndex<=10)
				{
					puts("ERROR: Sprites 1 through A are used by SMW and can't be changed with this tool");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				if (newIndex<=thisIndex)
				{
					puts("ERROR: sprites.txt must have the sprite with the lowest number first");
					fclose(tmpasm);
					remove("tmpasm.asm");
					return 1;
				}
				thisIndex=newIndex;
				fprintf(tmpasm, "db %%0%s\n", thisLine+3);
			}
			fclose(spritestxt);
		}
		else if (!strcmp(thisLine, ";TOOL LINE: warnpc"))
		{
			if (!foundFreespLine)
			{
				puts("ERROR: The warnpc tool line must be after the freespace tool line");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			if (foundWarnpcLine)
			{
				puts("ERROR: Two warnpc tool lines detected");
				fclose(tmpasm);
				remove("tmpasm.asm");
				return 1;
			}
			foundWarnpcLine=true;
			fprintf(tmpasm, "warnpc $%.2XFFFF\n", freespace);
		}
		else fprintf(tmpasm, "%s\n", thisLine);
	}
	fclose(originalasm);
	fclose(tmpasm);
	if (!foundFreespLine)
	{
		puts("ERROR: No freespace tool line");
		remove("tmpasm.asm");
		return 1;
	}
	if (!foundPtrsLine)
	{
		puts("ERROR: No pointers tool line");
		remove("tmpasm.asm");
		return 1;
	}
	if (!foundCodesLine)
	{
		puts("ERROR: No codes tool line");
		remove("tmpasm.asm");
		return 1;
	}
	if (!foundActiveLine)
	{
		puts("ERROR: No codes tool line");
		remove("tmpasm.asm");
		return 1;
	}
	if (!foundWarnpcLine)
	{
		puts("ERROR: No warnpc tool line");
		remove("tmpasm.asm");
		return 1;
	}
	//make a backup of the rom, in case there's an error somewhere
	FILE * backup=fopen("temp.bin","wb");
	rom=fopen(romname, "rb");
	fread(rombank, 1, 512, rom);
	fwrite(rombank, 1, 512, backup);
	for (int i=512;i<romsize;i+=32768)
	{
		fread(rombank, 1, 32768, rom);
		fwrite(rombank, 1, 32768, backup);
	}
	fclose(rom);
	sprintf(thisLine, "xkas tmpasm.asm %s > error.log", romname);
	system(thisLine);
	FILE * errlog=fopen("error.log", "rt");
	fseek(errlog, 0, SEEK_END);
	if (ftell(errlog))
	{
		rewind(errlog);
		fgets(thisLine, 250, errlog);
		printf("ERROR: xkas returned error: %s\nYour ROM has been restored from a backup.", thisLine);
		fclose(errlog);
		remove("error.log");
		remove("tmpasm.asm");
		//restore from the backup
		rom=fopen(romname, "wb");
		rewind(backup);
		fread(rombank, 1, 512, backup);
		fwrite(rombank, 1, 512, rom);
		for (int i=512;i<romsize;i+=32768)
		{
			fread(rombank, 1, 32768, backup);
			fwrite(rombank, 1, 32768, rom);
		}
		fclose(rom);
		fclose(backup);
		remove("temp.bin");
		return 1;
	}
	fclose(errlog);
	fclose(backup);
	remove("error.log");
	remove("tmpasm.asm");
	remove("temp.bin");
	return 0;
}
