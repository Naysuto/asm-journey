#include <stdio.h>
#include <string.h>

// Déclarations des fonctions ASM
extern unsigned long my_strlen(const char *s);
extern char *my_strcpy(char *dest, const char *src);
extern int my_memcmp(const void *a, const void *b, unsigned long n);

int main(void) {
    int failed = 0;

    // --- Test my_strlen ---
    if (my_strlen("hello") != 5) {
        printf("FAIL: my_strlen(\"hello\") != 5\n");
        failed++;
    }
    if (my_strlen("") != 0) {
        printf("FAIL: my_strlen(\"\") != 0\n");
        failed++;
    }
    if (my_strlen("a") != 1) {
        printf("FAIL: my_strlen(\"a\") != 1\n");
        failed++;
    }

    // --- Test my_strcpy ---
    char buf[64];
    char *ret = my_strcpy(buf, "world");
    if (ret != buf) {
        printf("FAIL: my_strcpy didn't return dest\n");
        failed++;
    }
    if (strcmp(buf, "world") != 0) {
        printf("FAIL: my_strcpy didn't copy correctly (got: %s)\n", buf);
        failed++;
    }

    // --- Test my_memcmp ---
    if (my_memcmp("abc", "abc", 3) != 0) {
        printf("FAIL: my_memcmp(\"abc\",\"abc\",3) != 0\n");
        failed++;
    }
    if (my_memcmp("abc", "abd", 3) >= 0) {
        printf("FAIL: my_memcmp(\"abc\",\"abd\",3) should be negative\n");
        failed++;
    }
    if (my_memcmp("abd", "abc", 3) <= 0) {
        printf("FAIL: my_memcmp(\"abd\",\"abc\",3) should be positive\n");
        failed++;
    }
    if (my_memcmp("abc", "abcdef", 3) != 0) {
        printf("FAIL: my_memcmp first 3 of \"abc\"/\"abcdef\" should be equal\n");
        failed++;
    }

    if (failed == 0) {
        printf("All tests passed!\n");
        return 0;
    } else {
        printf("%d test(s) failed.\n", failed);
        return 1;
    }
}
