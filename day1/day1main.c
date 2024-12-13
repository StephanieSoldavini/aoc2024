#include <stdio.h>
#include <stdint.h>

#define SIZE 1000
int day1asm(int64_t list1[SIZE], int64_t list2[SIZE], int size);

int main(int argc, char *argv[]){
    FILE* dataFile;
    int bufSize = 100;
    char line[bufSize];
    int64_t list1[SIZE];
    int64_t list2[SIZE];

    dataFile = fopen(argv[1], "r");
    if (dataFile != NULL) {
        int idx = 0;
        while (fgets(line, bufSize, dataFile) != NULL) {
            sscanf(line, "%lld %lld", &list1[idx], &list2[idx]);
            idx += 1;
        }
        fclose(dataFile);
        int64_t answer = day1asm(list1, list2, SIZE);
        /*
        for (int i = 0; i < SIZE; i++) {
            printf("%lld %lld\n", list1[i], list2[i]);
        }
        */
        printf("Final answer: %lld\n", answer);
    } else {
        printf("Unable to open file [%s]\n", argv[1]);
    }
    return 0;
}
