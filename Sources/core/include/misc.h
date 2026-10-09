//
//  misc.h
//  ExperimentsEverything
//
//  Created by Anbalagan on 02/09/26.
//

#ifndef MISC_H
#define MISC_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef const char *(*my_assert_message_provider_t)(void);

void my_assert(bool condition, my_assert_message_provider_t messageProvider);

#ifdef __cplusplus
}
#endif

#endif /* MISC_H */
