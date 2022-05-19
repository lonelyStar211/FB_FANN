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

function test_callback cdecl (ann as fann ptr , train as fann_train_data ptr, _
	max_epochs as ULONG, epochs_between_reports as ulong, _
	desired_error as single, epochs as ulong) as LONG

	printf(!"Epochs     %8d. MSE: %.5f. Desired-MSE: %.5f\n", epochs, fann_get_MSE(ann), desired_error)
	return 0
end function

function __main() as LONG

	dim as fann_type ptr calc_out
	const as ulong num_input = 2
	const as ulong num_output = 1
	const as ulong num_layers = 3
	const as ulong num_neurons_hidden = 3
	const as single desired_error = 0
	const as ulong max_epochs = 1000
	const as ulong epochs_between_reports = 10
	dim as fann ptr ann
	dim as fann_train_data ptr pdata

	dim as ulong i = 0
	dim as ulong decimal_point

	printf(!"Creating network.\n")
	ann = fann_create_standard(num_layers, num_input, num_neurons_hidden, num_output)

	pdata = fann_read_train_from_file("xor.data")

	fann_set_activation_steepness_hidden(ann, 1)
	fann_set_activation_steepness_output(ann, 1)

	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC)

	fann_set_train_stop_function(ann, FANN_STOPFUNC_BIT)
	fann_set_bit_fail_limit(ann, 0.01f)

	fann_set_training_algorithm(ann, FANN_TRAIN_RPROP)

	fann_init_weights(ann, pdata)
	
	printf(!"Training network.\n")
	fann_train_on_data(ann, pdata, max_epochs, epochs_between_reports, desired_error)

	printf(!"Testing network. %f\n", fann_test_data(ann, pdata))
	
	for i = 0 to fann_length_train_data(pdata) -1
		calc_out = fann_run(ann, pdata->input[i])
		printf(!"XOR test (%f,%f) -> %f, should be %f, difference=%f\n", _
			   pdata->input[i][0], pdata->input[i][1], calc_out[0], pdata->output[i][0], _
			   fann_abs(calc_out[0] - pdata->output[i][0]))
	next i

	printf(!"Saving network.\n")

	fann_save(ann, "xor_float.net")

	decimal_point = fann_save_to_fixed(ann, "xor_fixed.net")
	fann_save_train_to_fixed(pdata, "xor_fixed.data", decimal_point)

	printf(!"Cleaning up.\n")
	fann_destroy_train(pdata)
	fann_destroy(ann)
	
	sleep
	return 0
end function

end __main()