#include "crt.bi"
#include "fann.bi"

#define IsNot(_N) (_N)=0

function __main() as long 'int main( int argc, char** argv )
	dim as fann_type ptr calc_out
	dim as ulong i
	dim as long ret = 0
	dim as fann ptr ann
	dim as fann_train_data ptr pdata
	printf(!"Creating network.\n")
	ann = fann_create_from_file("scaling.net")
	if IsNot(ann) then	
		printf(!"Error creating ann --- ABORTING.\n")
		return 0
	end if
	fann_print_connections(ann)
	fann_print_parameters(ann)
	printf(!"Testing network.\n")
	pdata = fann_read_train_from_file("datasets/scaling.data")
	for i = 0 to fann_length_train_data(pdata)-1	
		fann_reset_MSE(ann)
    	fann_scale_input( ann, pdata->input[i] )
		calc_out = fann_run( ann, pdata->input[i] )
		fann_descale_output( ann, calc_out )
		printf(!"Result %f original %f error %f\n", _
			calc_out[0], pdata->output[i][0], _
			cast( single ,  fann_abs(calc_out[0] - pdata->output[i][0])) )
	next i
	printf(!"Cleaning up.\n")
	fann_destroy_train(pdata)
	fann_destroy(ann)
	sleep
	return ret
end function

end __main()
