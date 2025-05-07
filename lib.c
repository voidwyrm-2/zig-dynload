#include <stddef.h>
#include <stdio.h>

int add(int x, int y) { return x + y; }

size_t slen(const char *str) {
  size_t len = 0;
  while (str[len] != 0) {
    len++;
  }

  return len;
}

typedef struct {
  void (*out)(int);
} obj_t;

void call_struct(obj_t obj) { obj.out(20); }

void put(int x, int y) { printf("%d-%d\n", x, y); }

void (*fret(void))(int, int) { return put; }
