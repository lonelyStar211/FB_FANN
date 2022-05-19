#include "fann.bi"

function __main() as long '(argc as long, argv as zstring ptr ptr) as long

	const as ulong num_input = 3
	const as ulong num_output = 1
	const as ulong num_layers = 4
	const as ulong num_neurons_hidden = 5
	const as single desired_error = 0.0001
	const as ulong max_epochs = 5000
	const as ulong epochs_between_reports = 1000
	dim as fann_train_data ptr pdata = NULL
	dim as fann ptr ann = fann_create_standard(num_layers, num_input, num_neurons_hidden, num_neurons_hidden, num_output)
	fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
	fann_set_activation_function_output(ann, FANN_LINEAR)
	fann_set_training_algorithm(ann, FANN_TRAIN_RPROP)
	pdata = fann_read_train_from_file("datasets/scaling.data")
	fann_set_scaling_params( _
		    ann, _
			pdata, _
			-1,	_ '/* New input minimum */
			1,	_ '/* New input maximum */
			-1,	_ '/* New output minimum */
			1)	  '/* New output maximum */

	fann_scale_train( ann, pdata )

	fann_train_on_data(ann, pdata, max_epochs, epochs_between_reports, desired_error)
	fann_destroy_train( pdata )
	fann_save(ann, "scaling.net")
	fann_destroy(ann)
	sleep
	return 0
end function

end __main() ' __FB_ARGC__ , __fb_argv__ )