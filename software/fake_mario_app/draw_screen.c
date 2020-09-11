#include "draw_screen.h"

void draw_screen(int bg_idx, int level, mario_move_t* mario){
    volatile unsigned int *GPIO = (unsigned int*)0x90;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
| 31:30  | 29:27     | 26:24     | 23:21         | 20          | 19:10       | 9:0         |
| bg_idx | mario_idx | level_idx | level2_active | mario_alive | mario_pos_x | mario_pos_y |
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

    *GPIO =  (mario->pos_y_curr & MARIO_POS_Y_MASK) + 
             ((mario->pos_x_curr << 10) & MARIO_POS_X_MASK) +
             (((MARIO_ALIVE - mario->alive) << 20) & MARIO_ALIVE_MASK) +
             ((mario->level2_active << 21) & MARIO_LV2_MASK) +
             ((level << 24) & LEVEL_MASK) +
             ((mario->idx << 27) & MARIO_IDX_MASK) +
             ((bg_idx <<30) & BG_IDX_MASK);
    /*if (mario->level2_active != 0)
    {
        mario->level2_active = 0;
        *GPIO =  (mario->pos_y_curr & MARIO_POS_Y_MASK) + 
             ((mario->pos_x_curr << 10) & MARIO_POS_X_MASK) +
             (((MARIO_ALIVE - mario->alive) << 20) & MARIO_ALIVE_MASK) +
             ((mario->level2_active << 21) & MARIO_LV2_MASK) +
             ((level << 24) & LEVEL_MASK) +
             ((mario->idx << 27) & MARIO_IDX_MASK) +
             ((bg_idx <<30) & BG_IDX_MASK);
    }*/

}
