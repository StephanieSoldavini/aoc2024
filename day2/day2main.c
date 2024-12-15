#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
int64_t day2asm(uint8_t* data, int64_t totalsize);

int main(int argc, char *argv[]){
    FILE* dataFile;
    int bufSize = 100;
    char line[bufSize];

    dataFile = fopen(argv[1], "r");
    if (dataFile != NULL) {
        int idx = 0;
        int count = 0;
        uint8_t token_uint8;
        while (fgets(line, bufSize, dataFile) != NULL) {
            char* token = strtok(line, " ");
            while(token) {
                count++;
                token = strtok(NULL, " ");
            }
            idx++;
        }
        uint64_t totalsize = idx + count;
        uint8_t data[totalsize];
        rewind(dataFile);
        idx = 0;
        while (fgets(line, bufSize, dataFile) != NULL) {
            uint8_t size = 0;
            int sizeslot = idx;
            idx++;
            char* token = strtok(line, " ");
            while(token) {
                token_uint8 = (uint8_t) atoi(token);
                data[idx++] = token_uint8;
                token = strtok(NULL, " ");
                size++;
            }
            data[sizeslot] = size;
        }
        /*
        for (int i=0; i<totalsize; i++) {
            printf("%d ", data[i]);
        }
        printf("\n");
        */
        fclose(dataFile);
        int64_t answer = day2asm(data, totalsize);
        printf("Final answer: %lld\n", answer);
    } else {
        printf("Unable to open file [%s]\n", argv[1]);
    }
    return 0;
}
