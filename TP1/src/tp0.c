#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include "base64.h"
#include <unistd.h>

int do_action(int encode, int fdIn, int fdOut) 
{
	int r;

	if (encode)
		r = base64_encode(fdIn, fdOut);
	else
		r = base64_decode(fdIn, fdOut);

	return r;
}

void print_help() 
{
	fprintf(stdout,
		"Usage:\n"
		" tp0 -h\n"
		" tp0 -V\n"
		" tp0 [OPTIONS]\n"
		"Options:\n"
		" -V, --version\t Print version and quit.\n"
		" -h, --help \t Print this information.\n"
		" -i, --input \t Location of the input file.\n"
		" -o, --output \t Location of the output file.\n"
		" -a, --action \t Program action: encode (default) or decode.\n"
		"Examples:\n"
		" tp0 -a encode -i ~/input -o ~/output\n"
		" tp0 -a decode\n");
}

void print_version()
{
	fprintf(stdout, "Version 1.0\n");
}

void throw_error_selection() 
{
	fprintf(stderr, "Error: decode and encode selected.\n");
	print_help();
	exit(EXIT_FAILURE);
}

int get_file_descriptor(char* fileName, int in) 
{
	FILE *fp;

	char* action = "w"; //Write
	int fd = STDOUT_FILENO; //Out file

	if (in) {
		action = "r"; //Read
		fd = STDIN_FILENO; //In file
	}

	fp = fopen(fileName, action);
	if (fp != NULL) {
		fd = fileno(fp);
	}

	return fd;
}

int main(int argc,  char* const* argv)
{
	int encode = -1;
	int option;
	int in;
	char *enc="encode";
	char *dec="decode";

	extern char *optarg;
	extern int optind, opterr, optopt;

	int fdIn = STDIN_FILENO;
	int fdOut = STDOUT_FILENO;

	/* Una cadena que lista las opciones cortas válidas */
	const char* const opcionesCortas = "a:i:o:vh";

	/* Una estructura de varios arrays describiendo las opciones largas */
	const struct option opcionesLargas[] = {
		{ "help",	  no_argument, NULL,'h'},
		{ "version", no_argument, NULL,'v'},
		{ "input",no_argument, NULL,'i'},
		{ "output",no_argument, NULL,'o'},
		{ "action",no_argument, NULL,'a'},
		{ NULL,     no_argument, NULL, 0 }
	};

	opterr = 0;

	/* Lee todas las opciones ingresadas */
	while ((option = getopt_long(argc, argv, opcionesCortas, opcionesLargas, NULL)) != -1) {
		switch (option)
		{
			case 'a':
				if (encode == -1) {
					if (strcmp(optarg, enc) == 0)
						encode = 1;
					else if (strcmp(optarg, dec) == 0)
						encode = 0;
					else
						throw_error_selection();
				}
				break;
			case 'i':
				in = 1;
				fdIn = get_file_Descriptor(optarg, in);
				break;
			case 'o':
				in = 0;
				fdOut = get_file_Descriptor(optarg, in);
				break;
			case 'h':
				print_help();
				exit(EXIT_SUCCESS);
			case 'v':
				print_version();
				exit(EXIT_SUCCESS);
			case '?':
				if (optopt == 'i' || optopt == 'o' || optopt == 'a')
					fprintf (stderr, "Option -%c requires an argument.\n", optopt);
				else
					fprintf (stderr, "Unknown option character\n");
				print_help();
				exit(EXIT_FAILURE);
			default:
				abort();
		}
	}
    
    //Se llama a la accion
    do_action(encode, fdIn, fdOut);

	return 0;
}
