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

function __main() as LONG

	const as ulong num_layers = 3
	const as ULONG num_neurons_hidden = 32
	const as single desired_error = 0.0001
	const as ulong max_epochs = 300
	const as ulong epochs_between_reports = 10
	dim as fann ptr ann
	dim as fann_train_data ptr train_data, test_data

	dim as ulong i = 0

	printf(!"Creating network.\n")

	train_data = fann_read_train_from_file("datasets/mushroom.train")

	ann = fann_create_standard(num_layers, _
					  train_data->num_input, num_neurons_hidden, train_data->num_output)

	printf(!"Training network.\n")

	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_SIGMOID)

	'/*fann_set_training_algorithm(ann, FANN_TRAIN_INCREMENTAL) */

	fann_train_on_data(ann, train_data, max_epochs, epochs_between_reports, desired_error)

	printf(!"Testing network.\n")

	test_data = fann_read_train_from_file("datasets/mushroom.test")

	fann_reset_MSE(ann)
	for i = 0 to fann_length_train_data(test_data) - 1
		fann_test(ann, test_data->input[i], test_data->output[i])
	next i
	
	printf(!"MSE error on test data: %f\n", fann_get_MSE(ann))

	printf(!"Saving network.\n")

	fann_save(ann, "mushroom_float.net")

	printf(!"Cleaning up.\n")
	fann_destroy_train(train_data)
	fann_destroy_train(test_data)
	fann_destroy(ann)
	
	sleep
	return 0
end function

end __main()