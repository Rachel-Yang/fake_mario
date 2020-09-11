#include "spike.h"
#include "mario_move.h"
#include "block.h"
#include <string.h>

static int level_spike_info[SPIKE_NUM_MAX];
static int spike_num = 0;

static int level2_is_spike(int pos_x, int pos_y)
{
    volatile unsigned int *INFO = (unsigned int*)0x80;
    int spike_x = *INFO & 0x03FF;
    if (spike_x == 0)
        return 0;
    if (pos_y + MARIO_Y < 8 * BLOCK_WIDTH
     || pos_y > 13 * BLOCK_WIDTH)
        return 0;
    if (pos_x > spike_x - BLOCK_WIDTH
     && pos_x < spike_x
    )
        return 1;
    if (pos_x + MARIO_X > spike_x - BLOCK_WIDTH
     && pos_x + MARIO_X < spike_x
    )
        return 1;
    if (pos_x + MARIO_X / 2 > spike_x - BLOCK_WIDTH
     && pos_x + MARIO_X / 2 < spike_x
    )
        return 1;
    return 0;
}

static int point_is_spike(int pos_x, int pos_y)
{
    int flag = 0;
    for (int i = 0; i < spike_num; i++)
    {
        int spike_x = level_spike_info[i] % BLOCK_X_NUM;
        int spike_y = level_spike_info[i] / BLOCK_X_NUM;
        if (pos_x / BLOCK_WIDTH != spike_x
         || pos_y / BLOCK_WIDTH != spike_y)
            continue;
        int off_x = pos_x % BLOCK_WIDTH;
        int off_y = pos_y % BLOCK_WIDTH;
        if ((off_x < BLOCK_WIDTH / 2 && off_y > BLOCK_WIDTH - 2 * off_x)
         || (off_x > BLOCK_WIDTH / 2 && off_y > BLOCK_WIDTH - 2 * (BLOCK_WIDTH - off_x))
         )
            return 1;
    } 
    return flag;
}

int is_spike(int pos_x, int pos_y, int level)
{
    int flag = 0;
    if (level == 2
     && level2_is_spike(pos_x, pos_y))
        flag = 1;
    if (point_is_spike(pos_x, pos_y - 1)
     || point_is_spike(pos_x, pos_y + MARIO_Y - 1)
     || point_is_spike(pos_x + MARIO_X, pos_y - 1)
     || point_is_spike(pos_x + MARIO_X, pos_y + MARIO_Y - 1)
     || point_is_spike(pos_x + MARIO_X / 2, pos_y + MARIO_Y / 2)
     )
        flag = 1;
    return flag;
}

void set_spike(int x, int y, int set)
{
    if (set == SPIKE_SET)
    {
        level_spike_info[spike_num] = y * BLOCK_X_NUM + x;
        spike_num ++;
    }
    else
    {
        int start = 0;
        while (level_spike_info[start] != y * BLOCK_X_NUM + x)
            start ++;
        for (int i = start; i < spike_num - 1; i++)
        {
            level_spike_info[i] = level_spike_info[i+1];
        }
        spike_num --;
    }
}

void level_spike_info_init(int level)
{
    memset(level_spike_info, 0, sizeof(char) * SPIKE_NUM_MAX);
    spike_num = 0;
    switch (level)
    {
        case 0:
            break;
        case 1:
            set_spike(21, 20, SPIKE_SET);
            break;
        case 2:
            set_spike(13,  6, SPIKE_SET);
            set_spike(14,  6, SPIKE_SET);
            set_spike( 7, 17, SPIKE_SET);
            set_spike( 8, 17, SPIKE_SET);
            set_spike(29,  9, SPIKE_SET);
            break;
        default:
            break;
    }
}
