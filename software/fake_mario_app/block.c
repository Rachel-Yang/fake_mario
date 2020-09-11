#include "block.h"
#include "mario_move.h"
#include <string.h>

static char level_block_info[BLOCK_NUM];

int out_screen(int pos_x, int pos_y)
{
    int flag = 0;
    if (pos_y < MARIO_LOWER_LIMIT
     || pos_y + MARIO_Y > MARIO_UPPER_LIMIT)
        flag = 1;
    return flag;
}

void level2_set_block()
{
    volatile unsigned int *INFO = (unsigned int*)0x80;
    if (*INFO >> 31 == 0)
    {
        set_block(0, 5, 7, 1, BLOCK_UNSET);
    }
    else
    {
        set_block(0, 5, 7, 1, BLOCK_UNSET);
    }
}

int is_block(int pos_x, int pos_y)
{
    int x = pos_x / BLOCK_WIDTH;
    int y = pos_y / BLOCK_WIDTH;
    return (level_block_info[y * BLOCK_X_NUM + x] == 1);
}

int is_wall(int pos_x, int pos_y)
{
    int flag = 0;
    if ((1 == is_block(pos_x, pos_y))
     || (1 == is_block(pos_x, pos_y + MARIO_Y))
     || (1 == is_block(pos_x + MARIO_X, pos_y))
     || (1 == is_block(pos_x + MARIO_X, pos_y + MARIO_Y))
     || (1 == is_block(pos_x, pos_y + MARIO_Y / 2))
     || (1 == is_block(pos_x + MARIO_X, pos_y + MARIO_Y / 2))
    )
        flag = 1;
    return flag;
}

int is_ground(int pos_x, int pos_y)
{
    int flag = 0;
    if ((1 == is_block(pos_x, pos_y + MARIO_Y + 1))
     || (1 == is_block(pos_x + MARIO_X, pos_y + MARIO_Y + 1))
    )
        flag = 1;
    return flag;
}

int can_move(int pos_x, int pos_y, int level)
{
    int flag = 1;
    if (level == 2)
        level2_set_block();
    if (X_LOWER > pos_x
     || X_UPPER < pos_x + MARIO_X
     || Y_LOWER > pos_y
     || Y_UPPER < pos_y + MARIO_Y)
        flag = 0;
    if (is_wall(pos_x, pos_y))
        flag = 0;
    
    return flag;
}

void set_block(int x_start, int x_num, int y_start, int y_num, char set)
{
    for (int y = y_start; y < y_start + y_num; y++)
        for (int x = x_start; x < x_start + x_num; x++) 
            level_block_info[y * BLOCK_X_NUM + x] = set;   
}

void level_block_info_init(int level)
{
    memset(level_block_info, BLOCK_UNSET, sizeof(char) * BLOCK_NUM);
    switch (level)
    {
        case 0:
            break;
        case 1:
            set_block( 0, 2, 18, 6, BLOCK_SET);
            set_block( 2, 6, 21, 3, BLOCK_SET);
            set_block( 8, 2, 20, 4, BLOCK_SET);
            set_block(12, 2, 20, 4, BLOCK_SET);
            set_block(16, 3, 20, 4, BLOCK_SET);
            set_block(19, 6, 21, 3, BLOCK_SET);
            set_block(25, 4, 18, 6, BLOCK_SET);
            set_block(29, 3, 17, 7, BLOCK_SET);
            break;
        case 2:
            set_block( 5, 21,  7, 1, BLOCK_SET);
            set_block( 0, 18, 13, 1, BLOCK_SET);
            set_block( 0, 18, 18, 6, BLOCK_SET);
            set_block(23,  1,  8, 9, BLOCK_SET);
            set_block(24,  2, 13, 1, BLOCK_SET);
            set_block(24,  8, 16, 1, BLOCK_SET);
            set_block(28,  4, 10, 1, BLOCK_SET);
            break;
        default:
            break;
    }
}
