#include <stdlib.h>
#include <stdio.h>
#include "libinjection.h"

char* getline2(FILE* f)
{
    size_t size = 0;
    size_t len  = 0;
    size_t last = 0;
    char* buf  = NULL;
    do {
        size += BUFSIZ;
        buf = realloc(buf, size);
        fgets(buf+last, size, f);
        len = strlen(buf);
        last = len - 1;
    } while (!feof(f) && buf[last]!='\n');
    return buf;
}

int main() {
    char* token;
    size_t slen;
    int issqli;
    char fingerprint[8];
    int isxss;
    int index = 0;

    token = getline2(stdin);
    while(!feof(stdin)) {
        slen = strlen(token);
        issqli = libinjection_sqli(token, slen, fingerprint);
        isxss = libinjection_xss(token, slen);
        free(token);

        if (issqli) {
            printf("%d:SQLI:1:%s\n", index, fingerprint);
        } else {
            printf("%d:SQLI:0\n", index);
        }
        if (isxss) {
            printf("%d:XSS:1\n", index);
        } else {
            printf("%d:XSS:0\n", index);
        }
        token = getline2(stdin);
        index++;
    }

    return 0;
}

