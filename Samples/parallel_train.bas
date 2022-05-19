/'
Fast Artificial Neural Network Library (fann)
Copyright (C) 2003-2016 Steffen Nissen (steffen.fann@gmail.com)

This library is free software you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'/

#include "crt.bi"

#include "fann.bi"
#include "parallel_fann.bi"

function __main(argc as long, argv as zstring ptr ptr) as long

	const as ulong max_epochs = 1000
	dim as ulong num_threads = 1
	dim as fann_train_data ptr pdata
	dim as fann ptr ann
	dim as longint before
	dim as single ferror_num
	dim as ulong i
	

	if argc = 2 then num_threads = atoi(argv[1])
		
	pdata = fann_read_train_from_file("datasets/mushroom.train")
	ann = fann_create_standard(3, fann_num_input_train_data(pdata), 32, fann_num_output_train_data(pdata))

	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_SIGMOID)

	before = GetTickCount()
	for i = 1 to max_epochs
		ferror_num = iif(num_threads > 1, fann_train_epoch_irpropm_parallel(ann, pdata, num_threads) , fann_train_epoch(ann, pdata))
		printf(!"Epochs     %8d. Current error: %.10f\n", i, ferror_num)
	next i
    printf(!"Threads: %d\n",num_threads)
	printf(!"ticks %d\n", GetTickCount()-before )

	fann_destroy(ann)
	fann_destroy_train(pdata)
	
	sleep
	return 0
end function

end __main( __FB_ARGC__ , __fb_argv__ )
