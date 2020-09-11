#ifndef SPIKE_H
#define SPIKE_H

// Spike Info
#define SPIKE_NUM_MAX 20
#define SPIKE_SET   1
#define SPIKE_UNSET 0

int is_spike(int pos_x, int pos_y, int level);
void level_spike_info_init(int level);

#endif
