#ifndef LEVEL_HANDLE_H
#define LEVEL_HANDLE_H
#include "mario_move.h"

// Level Info
#define MARIO_LOWER_LIMIT 10
#define MARIO_UPPER_LIMIT (Y_UPPER - MARIO_LOWER_LIMIT)
#define MARIO_LV1_LEFT_LIMIT 5
#define MARIO_LV1_RIGHT_LIMIT (X_UPPER - MARIO_LV1_LEFT_LIMIT)

int handle_level(mario_move_t* mario, int level);
int handle_keycode(mario_move_t* mario, int level, int keycode);

#endif
