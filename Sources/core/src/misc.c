#include "misc.h"
#include <stdio.h>

void my_assert(bool condition, my_assert_message_provider_t messageProvider) {
    if (!condition) {
        const char *message = messageProvider ? messageProvider() : NULL;
        fprintf(stderr, "Assertion failed: %s\n", message ? message : "(no message)");
    }
}
