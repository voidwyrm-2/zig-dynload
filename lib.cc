#include <iostream>
#include <stddef.h>

extern "C" int add(int x, int y) { return x + y; }

extern "C" size_t slen(const char *str) {
  size_t len = 0;
  while (str[len] != 0) {
    len++;
  }

  return len;
}

typedef struct {
  void (*out)(int);
} obj_t;

extern "C" void call_struct(obj_t obj) { obj.out(22); }

extern "C" class Test {
public:
  static void put(int x, int y) { std::cout << x << " AND THEN " << y << "\n"; }
};

extern "C" void (*fret(void))(int, int) {
  Test *t = new Test();
  return t->put;
}
