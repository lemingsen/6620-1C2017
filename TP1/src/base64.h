#ifndef BASE64_H_
#define BASE64_H_

extern const char* errmsg[];

extern int base64_encode(int fdIn, int fdOut);

extern int base64_decode(int fdIn, int fdOut);

#endif /* BASE64_H_ */
