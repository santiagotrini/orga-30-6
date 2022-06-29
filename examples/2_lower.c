#include <stdio.h>

void lower(char *str) {
  int i = 0;
  while (str[i] != 0) {
    if (str[i] >= 'A' && str[i] <= 'Z')
      str[i] = str[i] ^ 0x20;  // bitwise XOR (xori en MIPS)
    i++;
  }
  return;
}

int main(int argc, char *argv[]) {
  lower(argv[1]);
  printf("%s\n", argv[1]);
  return 0;
}
