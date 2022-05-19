#pragma once

#ifdef __FB_WIN32__
	#include once "crt/long.bi"
#else
	#include once "crt/sys/time.bi"
#endif

#include once "crt/stdio.bi"
#include once "crt/math.bi"
#include once "crt/stdlib.bi"

#include once "fann.bi"

extern "C"

declare function fann_train_epoch_batch_parallel(byval ann as fann ptr, byval data as fann_train_data ptr, byval threadnumb as const ulong) as single
declare function fann_train_epoch_irpropm_parallel(byval ann as fann ptr, byval data as fann_train_data ptr, byval threadnumb as const ulong) as single
declare function fann_train_epoch_quickprop_parallel(byval ann as fann ptr, byval data as fann_train_data ptr, byval threadnumb as const ulong) as single
declare function fann_train_epoch_sarprop_parallel(byval ann as fann ptr, byval data as fann_train_data ptr, byval threadnumb as const ulong) as single
declare function fann_train_epoch_incremental_mod(byval ann as fann ptr, byval data as fann_train_data ptr) as single
declare function fann_test_data_parallel(byval ann as fann ptr, byval data as fann_train_data ptr, byval threadnumb as const ulong) as single

end extern
