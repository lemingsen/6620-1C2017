#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>

#define ALPHABET "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
#define ALPHABET_LENGTH 64
#define ENDING_CHAR '='
#define ENDING_CHAR_INT 61
#define ENCODE_SIZE 6
#define DECODE_SIZE 8
#define BUFFERSIZE 12

void error()
{
	fprintf(stderr, "Error al decodificar\n");
	exit(EXIT_FAILURE);
}

int indexOf(char aChar){
	int i;
	for(i= 0;i < ALPHABET_LENGTH;i++){
		char alph_char = ALPHABET[i];
		if(alph_char == aChar)
			return i;
	}
	error();
	return -1;
}

int count = 0;
int linecount = 0;
int acum = 0;
int length = 0;

void doEncode(int value)
{
	acum = (acum << 1) | value;
	count++;
	if(count == ENCODE_SIZE){		
		++length;
		++linecount;
		putc((int)ALPHABET[acum], stdout);
		if (linecount == 76){
			putc('\n', stdout);
			linecount = 0;
		}
		count = 0;
		acum = 0;
	}
}

void encode64(char * const input, size_t amount)
{
	int i,j;

	for (i = 0; i< amount; i++)
	{
		char aChar =  input[i];
		for (j = DECODE_SIZE -1 ; j >=0 ; --j)
			doEncode(((aChar >> j) & 0x01));
	}
}

void doDecode(int value)
{
	acum = (acum << 1) | value;
	count++;
	if(count == DECODE_SIZE){		
		++length;
		putc(acum, stdout);
		count = 0;
		acum = 0;
	}
}

void decode64(char * const input, size_t amount)
{
	int i,j;
	char aChar;

	for (i = 0; i< amount && (input[i] != ENDING_CHAR); i++)
	{
		if (input[i] != '\n') {
			int index =  indexOf(input[i]);
			aChar =  index;
			for (j = ENCODE_SIZE - 1; j >= 0; j--)
				doDecode(((aChar >> j) & 0x01));
		}
	}
}

void process(int encode, char* buffer, size_t amount)
{
	if (encode)
		encode64(buffer, amount);
	else
		decode64(buffer, amount);
}

void closeProcess(int encode)
{
	int i;
	if(encode)
	{
		if(count < ENCODE_SIZE && count > 0)
		{
			while(count != 0)
			{
				doEncode(0);
			}

			for (i = 0; i < 4 - length % 4; i++)
				putc(ENDING_CHAR_INT, stdout);
		}
	}
	fflush(stdout);
}

void openInFile(char * file){
	FILE * ifp = freopen(file, "rb", stdin);
	if (ifp == NULL) {
	  fprintf(stderr, "Can't open input file\n");
	  exit(EXIT_FAILURE);
	}
}

void openOutFile(char * file){
	FILE * ofp = freopen(file, "wb", stdout);
	if (ofp == NULL) {
	  fprintf(stderr, "Can't open output file\n");
	  exit(EXIT_FAILURE);
	}
}

void print_help(){
	fprintf(stdout, "Modo de empleo: ./tp0 [OPTIONS]\n"
"OPTIONS:\n"
"-e --encode Encodes to Base64\n"
"-d --decode Decodes from Base64\n"
"-i --input file Reads from file or stdin\n"
"-o --output file Writes to file or stdout\n"
"-v --version Show version string\n"
"-h --help Print this message and quit\n");
}

void print_version(){
	fprintf(stdout, "Version 1.0\n");
}

void selectionError() {
	fprintf(stderr, "Error: decode and encode selected.\n");
	print_help();
	exit(EXIT_FAILURE);
}
int main(int argc,  char* const* argv)
{
	int encode = -1;
	int c;
	char *enc="encode";
	char *dec="decode";
	extern char *optarg;
	extern int optind, opterr, optopt;
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

	while ((c = getopt_long(argc, argv, opcionesCortas, opcionesLargas, NULL)) != -1)
	 switch (c)
	   {
	   case 'a':
	     if (encode == -1) {
	     	if (strcmp(optarg, enc) == 0)
	    		encode = 1;
	    	else if (strcmp(optarg, dec) == 0)
	    		encode = 0;
		    else
		    	selectionError();
		}
	     break;
	   case 'i':
	     openInFile(optarg);
	     break;
	   case 'o':
	     openOutFile(optarg);
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
	     abort ();
	   }

     /*************************************************************/

	char buffer[BUFFERSIZE];
	size_t amount;

	while (1) /* break with ^D or ^Z */
	{
		amount=fread(buffer, 1, BUFFERSIZE , stdin);
		process(encode, buffer, amount);
		if(feof(stdin))
			break;
	}

	closeProcess(encode);
	fclose (stdin);
	fclose (stdout);

	return 0;
}
