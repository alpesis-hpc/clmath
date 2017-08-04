#include "clmath/utils/file_handler.h"

int main ()
{
  char * kernel = file_read ("clmath/src/clmath/kernels/vector_add.cl");
  if (kernel)
  {
    puts (kernel);
    free (kernel);
  }

  return 0;
}
