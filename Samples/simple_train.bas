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

#include "fann.bi"

#include "crt.bi"

function __main() as long

	const as ulong num_input = 2
	const as ulong num_output = 1
	const as ulong num_layers = 3
	const as ulong num_neurons_hidden = 3
	const as single desired_error = 0.001
	const as ulong max_epochs = 500000
	const as ulong epochs_between_reports = 1000

	dim as fann ptr ann = fann_create_standard(num_layers, num_input, num_neurons_hidden, num_output)

	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC)

	fann_train_on_file(ann, "xor.data", max_epochs, epochs_between_reports, desired_error)

	fann_save(ann, "xor_float.net")

	fann_destroy(ann)
	
	sleep
	
	return 0
end function

end __main()