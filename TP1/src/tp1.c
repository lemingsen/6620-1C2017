#include <stdio.h>
#include <unistd.h>

extern int base64_encode(int fdIn, int fdOut);

int main(int argc,  char* const* argv)
{
	FILE *fpIn;
	FILE *fpOut;
	int fdIn, fdOut;

	fpIn = fopen("input.txt", "r");
	if (fpIn != NULL)
		fdIn = fileno(fpIn);
	else {
		fprintf(stderr, "Error: input.txt.\n");
		exit(1);
	}

	fpOut = fopen("output.txt", "w");
	if (fpOut != NULL)
		fdOut = fileno(fpOut);
	else {
		fprintf(stderr, "Error: output.txt.\n");
		exit(1);
	}

	base64_encode(fdIn, fdOut);

	return 0;
}

