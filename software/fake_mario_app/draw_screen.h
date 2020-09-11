#include "mario_move.h"

#define MARIO_POS_Y_MASK 0x000003FF
#define MARIO_POS_X_MASK 0x000FFC00
#define MARIO_ALIVE_MASK 0x00100000
#define MARIO_LV2_MASK   0x00E00000
#define LEVEL_MASK       0x07000000
#define MARIO_IDX_MASK   0x38000000
#define BG_IDX_MASK      0xC0000000

void draw_screen(int bg_idx, int level, mario_move_t* mario);
