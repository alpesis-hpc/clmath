#ifndef CL_ENGINE_H
#define CL_ENGINE_H

void engine_start (DEVICE * device, const size_t * global_work_size,
                                    const size_t * local_work_size,
                                    char * kernelpath);

#endif