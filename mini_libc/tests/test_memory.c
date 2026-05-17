#include <stdio.h>
#include <string.h>

extern int   my_memcmp(const void *a, const void *b, unsigned long n);
extern void *my_memset(void *dest, int c, unsigned long n);
extern void *my_memcpy(void *dest, const void *src, unsigned long n);
extern int   my_strncmp(const char *a, const char *b, unsigned long n);
extern char *my_strchr(const char *s, int c);

int main(void) {
    int failed = 0;

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

    // --- Test my_memset ---
    char sbuf[16];
    void *sret = my_memset(sbuf, 'X', 8);
    if (sret != sbuf) {
        printf("FAIL: my_memset didn't return dest\n");
        failed++;
    }
    for (int i = 0; i < 8; i++) {
        if (sbuf[i] != 'X') {
            printf("FAIL: my_memset byte %d != 'X'\n", i);
            failed++;
            break;
        }
    }
    my_memset(sbuf, 0, 16);
    for (int i = 0; i < 16; i++) {
        if (sbuf[i] != 0) {
            printf("FAIL: my_memset zero-fill failed at byte %d\n", i);
            failed++;
            break;
        }
    }
    // n == 0 : buffer ne doit pas être touché
    sbuf[0] = 'A';
    my_memset(sbuf, 'Z', 0);
    if (sbuf[0] != 'A') {
        printf("FAIL: my_memset n=0 modified buffer\n");
        failed++;
    }

    // --- Test my_memcpy ---
    char src[] = "hello";
    char dst[16];
    void *cret = my_memcpy(dst, src, 6);
    if (cret != dst) {
        printf("FAIL: my_memcpy didn't return dest\n");
        failed++;
    }
    if (memcmp(dst, "hello", 6) != 0) {
        printf("FAIL: my_memcpy content mismatch\n");
        failed++;
    }
    // n == 0 : buffer ne doit pas être touché
    dst[0] = 'Z';
    my_memcpy(dst, src, 0);
    if (dst[0] != 'Z') {
        printf("FAIL: my_memcpy n=0 modified buffer\n");
        failed++;
    }

    // --- Test my_strncmp ---
    if (my_strncmp("abc", "abc", 3) != 0) {
        printf("FAIL: my_strncmp equal strings != 0\n");
        failed++;
    }
    if (my_strncmp("abc", "abd", 3) >= 0) {
        printf("FAIL: my_strncmp(\"abc\",\"abd\",3) should be negative\n");
        failed++;
    }
    if (my_strncmp("abd", "abc", 3) <= 0) {
        printf("FAIL: my_strncmp(\"abd\",\"abc\",3) should be positive\n");
        failed++;
    }
    if (my_strncmp("abcX", "abcY", 3) != 0) {
        printf("FAIL: my_strncmp should stop at n=3\n");
        failed++;
    }
    if (my_strncmp("abc", "abc", 0) != 0) {
        printf("FAIL: my_strncmp n=0 should return 0\n");
        failed++;
    }

    // --- Test my_strchr ---
    const char *hay = "hello";
    char *p = my_strchr(hay, 'l');
    if (p != hay + 2) {
        printf("FAIL: my_strchr('l') didn't return correct pointer\n");
        failed++;
    }
    if (my_strchr(hay, 'z') != NULL) {
        printf("FAIL: my_strchr absent char should return NULL\n");
        failed++;
    }
    // recherche du null terminator
    p = my_strchr(hay, '\0');
    if (p != hay + 5) {
        printf("FAIL: my_strchr('\\0') should return pointer to null terminator\n");
        failed++;
    }
    // caractère en position 0
    if (my_strchr(hay, 'h') != hay) {
        printf("FAIL: my_strchr first char should return hay\n");
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
