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

sub train_on_steepness_file(ann as fann ptr, filename as zstring ptr, _
							 max_epochs as ulong, epochs_between_reports as ulong, _
							 desired_error as single, steepness_start as single, _
							 steepness_step as single, steepness_end as SINGLE)

	dim as single num_error
	dim as ulong i

	dim as fann_train_data ptr pdata = fann_read_train_from_file(filename)

	if(epochs_between_reports) then
		printf(!"Max epochs %8d. Desired error: %.10f\n", max_epochs, desired_error)
	end if

	fann_set_activation_steepness_hidden(ann, steepness_start)
	fann_set_activation_steepness_output(ann, steepness_start)
	for i = 1 to max_epochs 
	'for(i = 1 i <= max_epochs i++)
	
		'/* train */
		num_error = fann_train_epoch(ann, pdata)

		'/* print current output */
		if (epochs_between_reports andalso (((i mod epochs_between_reports) = 0) orelse (i = max_epochs) orelse (i = 1) orelse (num_error < desired_error))) then
		
			printf(!"Epochs     %8d. Current error: %.10f\n", i, num_error)
		end if

		if(num_error < desired_error) then
		
			steepness_start += steepness_step
			if(steepness_start <= steepness_end) then
			
				printf(!"Steepness: %f\n", steepness_start)
				fann_set_activation_steepness_hidden(ann, steepness_start)
				fann_set_activation_steepness_output(ann, steepness_start)
			
			else
			
				exit for
			end if
		end if
	next i
	fann_destroy_train(pdata)
end sub

function __main() as LONG

	const as ULONG num_input = 2
	const as ulong  num_output = 1
	const as ulong num_layers = 3
	const as ulong num_neurons_hidden = 3
	const as SINGLE desired_error = 0.001
	const as ulong max_epochs = 500000
	const as ulong epochs_between_reports = 1000
	dim as ulong i
	dim as fann_type ptr calc_out

	dim as fann_train_data ptr pdata

	dim as fann ptr ann = fann_create_standard(num_layers, _
								   num_input, num_neurons_hidden, num_output)

	pdata = fann_read_train_from_file("xor.data")

	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC)

	fann_set_training_algorithm(ann, FANN_TRAIN_QUICKPROP)

	train_on_steepness_file(ann, "xor.data", max_epochs, _
							epochs_between_reports, desired_error, cast(single, 1.0), cast(single, 0.1), _
							cast(single, 20.0) )

	fann_set_activation_function_hidden(ann, FANN_THRESHOLD_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_THRESHOLD_SYMMETRIC)

	'for(i = 0 i != fann_length_train_data(data) i++)		
	for i = 0 to fann_length_train_data(pdata)-1		
		calc_out = fann_run(ann, pdata->input[i])
		printf(!"XOR test (%f, %f) -> %f, should be %f, difference=%f\n", _
			   pdata->input[i][0], pdata->input[i][1], calc_out[0], pdata->output[i][0], _
			   cast(single, fann_abs(calc_out[0] - pdata->output[i][0])))
	next i


	fann_save(ann, "xor_float.net")

	fann_destroy(ann)
	fann_destroy_train(pdata)
	sleep
	return 0
end function

end __main()
