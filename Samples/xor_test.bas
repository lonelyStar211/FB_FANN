#include "fann.bi"

function __main2() as long
    const as ulong num_input = 2
    const as ulong num_output = 1
    const as ulong num_layers = 3
    const as ulong num_neurons_hidden = 3
    const as single desired_error =  cast(const single,0.001)
    const as ulong max_epochs = 500000
    const as ulong epochs_between_reports = 1000

    dim as fann ptr ann = fann_create_standard(num_layers, num_input, _
        num_neurons_hidden, num_output)

    fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC)
    fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC)

    fann_train_on_file(ann, "xor.data", max_epochs, _
        epochs_between_reports, desired_error)

    fann_save(ann, "xor_float.net")

    fann_destroy(ann)

    return 0
end function 

'__main2()
