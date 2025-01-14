#ifndef PS5SDK_KERNEL_H
#define PS5SDK_KERNEL_H

#include <sys/types.h>

extern const intptr_t KERNEL_ADDRESS_DATA_BASE;
extern const intptr_t KERNEL_ADDRESS_ALLPROC;

// Proc field offsets
extern const off_t KERNEL_OFFSET_PROC_P_UCRED;
extern const off_t KERNEL_OFFSET_PROC_P_PID;

// Ucred field offsets
extern const off_t KERNEL_OFFSET_UCRED_CR_UID;
extern const off_t KERNEL_OFFSET_UCRED_CR_RUID;
extern const off_t KERNEL_OFFSET_UCRED_CR_SVUID;
extern const off_t KERNEL_OFFSET_UCRED_CR_RGID;

uint32_t kernel_get_fw_version(void);
int32_t  kernel_copyin(const void *udaddr, intptr_t kaddr, size_t len);
int32_t  kernel_copyout(const intptr_t kaddr, void *udaddr, size_t  len);

#endif // PS5SDK_KERNEL_H
