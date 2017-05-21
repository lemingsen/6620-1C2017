#include <stdio.h>
#include <unistd.h>

extern int base64_encode(int fdIn, int fdOut);

int main(int argc,  char* const* argv)
{
	FILE *fpIn;
	FILE *fpOut;
	int fdIn, fdOut;

	// fpIn = fopen("input_encode.txt", "r");
	// if (fpIn != NULL)
	// 	fdIn = fileno(fpIn);
	// else {
	// 	fprintf(stderr, "Error: input_encode.txt.\n");
	// 	exit(1);
	// }

	// fpOut = fopen("output_encode.txt", "w");
	// if (fpOut != NULL)
	// 	fdOut = fileno(fpOut);
	// else {
	// 	fprintf(stderr, "Error: output_encode.txt.\n");
	// 	exit(1);
	// }

	// base64_encode(fdIn, fdOut);

	fpIn = fopen("input_decode.txt", "r");
	if (fpIn != NULL)
		fdIn = fileno(fpIn);
	else {
		fprintf(stderr, "Error: input_decode.txt.\n");
		exit(1);
	}

	fpOut = fopen("output_decode.txt", "w");
	if (fpOut != NULL)
		fdOut = fileno(fpOut);
	else {
		fprintf(stderr, "Error: output_decode.txt.\n");
		exit(1);
	}

	base64_decode(fdIn, fdOut);

	return 0;
}

