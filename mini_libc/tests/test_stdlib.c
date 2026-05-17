#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int   my_atoi(const char *s);
extern char *my_itoa(int n, char *buf, int base);
extern long  my_strtol(const char *s, char **endptr, int base);

int main(void) {
    int  failed = 0;
    char buf[64];
    char *end;

    // --- Test my_atoi ---
    if (my_atoi("42") != 42) {
        printf("FAIL: my_atoi(\"42\") != 42\n");
        failed++;
    }
    if (my_atoi("-42") != -42) {
        printf("FAIL: my_atoi(\"-42\") != -42\n");
        failed++;
    }
    if (my_atoi("+42") != 42) {
        printf("FAIL: my_atoi(\"+42\") != 42\n");
        failed++;
    }
    if (my_atoi("  42") != 42) {
        printf("FAIL: my_atoi(\"  42\") != 42 (leading spaces)\n");
        failed++;
    }
    if (my_atoi("0") != 0) {
        printf("FAIL: my_atoi(\"0\") != 0\n");
        failed++;
    }
    if (my_atoi("42abc") != 42) {
        printf("FAIL: my_atoi(\"42abc\") != 42 (stops at non-digit)\n");
        failed++;
    }

    // --- Test my_itoa ---
    char *ret = my_itoa(123, buf, 10);
    if (ret != buf) {
        printf("FAIL: my_itoa didn't return buf\n");
        failed++;
    }
    if (strcmp(buf, "123") != 0) {
        printf("FAIL: my_itoa(123, 10) = \"%s\", expected \"123\"\n", buf);
        failed++;
    }

    my_itoa(-456, buf, 10);
    if (strcmp(buf, "-456") != 0) {
        printf("FAIL: my_itoa(-456, 10) = \"%s\", expected \"-456\"\n", buf);
        failed++;
    }

    my_itoa(0, buf, 10);
    if (strcmp(buf, "0") != 0) {
        printf("FAIL: my_itoa(0, 10) = \"%s\", expected \"0\"\n", buf);
        failed++;
    }

    my_itoa(255, buf, 16);
    if (strcmp(buf, "ff") != 0) {
        printf("FAIL: my_itoa(255, 16) = \"%s\", expected \"ff\"\n", buf);
        failed++;
    }

    my_itoa(8, buf, 2);
    if (strcmp(buf, "1000") != 0) {
        printf("FAIL: my_itoa(8, 2) = \"%s\", expected \"1000\"\n", buf);
        failed++;
    }

    // --- Test my_strtol ---
    if (my_strtol("42", NULL, 10) != 42L) {
        printf("FAIL: my_strtol(\"42\", NULL, 10) != 42\n");
        failed++;
    }
    if (my_strtol("-42", NULL, 10) != -42L) {
        printf("FAIL: my_strtol(\"-42\", NULL, 10) != -42\n");
        failed++;
    }
    if (my_strtol("  42", NULL, 10) != 42L) {
        printf("FAIL: my_strtol(\"  42\", NULL, 10) != 42 (leading spaces)\n");
        failed++;
    }
    if (my_strtol("ff", NULL, 16) != 255L) {
        printf("FAIL: my_strtol(\"ff\", NULL, 16) != 255\n");
        failed++;
    }
    if (my_strtol("0xff", NULL, 16) != 255L) {
        printf("FAIL: my_strtol(\"0xff\", NULL, 16) != 255\n");
        failed++;
    }
    if (my_strtol("0xff", NULL, 0) != 255L) {
        printf("FAIL: my_strtol(\"0xff\", NULL, 0) != 255 (auto base)\n");
        failed++;
    }
    if (my_strtol("010", NULL, 0) != 8L) {
        printf("FAIL: my_strtol(\"010\", NULL, 0) != 8 (octal auto)\n");
        failed++;
    }
    if (my_strtol("1000", NULL, 2) != 8L) {
        printf("FAIL: my_strtol(\"1000\", NULL, 2) != 8 (binary)\n");
        failed++;
    }

    // endptr
    const char *s = "42abc";
    long val = my_strtol(s, &end, 10);
    if (val != 42L) {
        printf("FAIL: my_strtol endptr value != 42\n");
        failed++;
    }
    if (end != s + 2) {
        printf("FAIL: my_strtol endptr points to wrong position\n");
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
