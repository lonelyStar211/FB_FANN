#pragma once

#ifdef __FB_WIN32__
	#include once "crt/long.bi"
#else
	#include once "crt/sys/time.bi"
#endif

#inclib "fann"
#ifdef fixedfann
  #inclib "fixedfann"
#else
  #inclib "floatfann"
#endif


#include once "crt/stdio.bi"
#include once "crt/math.bi"
#include once "crt/stdlib.bi"

extern "C"

#define PARALLEL_FANN_H_
#define __floatfann_h__
type fann_type as single
#undef FLOATFANN
#define FLOATFANN
#define FANNPRINTF "%.20e"
#define FANNSCANF "%f"
#define FANN_INCLUDE

#ifdef __FB_WIN32__
	declare function GetTickCount stdcall() as culong
#else
    function GetTickCount() as ulong
    	static as double dTmr = 0
    	if dTmr=0 then dTmr = timer
    	return (timer-dTmr)*1000
    End Function
#endif

#define __fann_h__
#ifndef NULL
const NULL = 0
#endif
#define FANN_EXTERNAL
#define FANN_API
#define __fann_error_h__
const FANN_ERRSTR_MAX = 128

type fann_errno_enum as long
enum
	FANN_E_NO_ERROR = 0
	FANN_E_CANT_OPEN_CONFIG_R
	FANN_E_CANT_OPEN_CONFIG_W
	FANN_E_WRONG_CONFIG_VERSION
	FANN_E_CANT_READ_CONFIG
	FANN_E_CANT_READ_NEURON
	FANN_E_CANT_READ_CONNECTIONS
	FANN_E_WRONG_NUM_CONNECTIONS
	FANN_E_CANT_OPEN_TD_W
	FANN_E_CANT_OPEN_TD_R
	FANN_E_CANT_READ_TD
	FANN_E_CANT_ALLOCATE_MEM
	FANN_E_CANT_TRAIN_ACTIVATION
	FANN_E_CANT_USE_ACTIVATION
	FANN_E_TRAIN_DATA_MISMATCH
	FANN_E_CANT_USE_TRAIN_ALG
	FANN_E_TRAIN_DATA_SUBSET
	FANN_E_INDEX_OUT_OF_BOUND
	FANN_E_SCALE_NOT_PRESENT
	FANN_E_INPUT_NO_MATCH
	FANN_E_OUTPUT_NO_MATCH
	FANN_E_WRONG_PARAMETERS_FOR_CREATE
end enum

type fann_error as fann_error_
declare sub fann_set_error_log(byval errdat as fann_error ptr, byval log_file as FILE ptr)
declare function fann_get_errno(byval errdat as fann_error ptr) as fann_errno_enum
declare sub fann_reset_errno(byval errdat as fann_error ptr)
declare sub fann_reset_errstr(byval errdat as fann_error ptr)
declare function fann_get_errstr(byval errdat as fann_error ptr) as zstring ptr
declare sub fann_print_error(byval errdat as fann_error ptr)
extern fann_default_error_log as FILE ptr

#define __fann_activation_h__
#define FANN_EXP(x) expf(x)
'#define FANN_SIN(x) sinf(x)
'#define FANN_COS(x) cosf(x)
#define fann_linear_func(v1, r1, v2, r2, sum) (((((r2) - (r1)) * ((sum) - (v1))) / ((v2) - (v1))) + (r1))
#define fann_stepwise(v1, v2, v3, v4, v5, v6, r1, r2, r3, r4, r5, r6, min, max, sum) iif(sum < v5, iif(sum < v3, iif(sum < v2, iif(sum < v1, min, fann_linear_func(v1, r1, v2, r2, sum)), fann_linear_func(v2, r2, v3, r3, sum)), iif(sum < v4, fann_linear_func(v3, r3, v4, r4, sum), fann_linear_func(v4, r4, v5, r5, sum))), iif(sum < v6, fann_linear_func(v5, r5, v6, r6, sum), max))
#define fann_linear_derive(steepness, value) (steepness)
#define fann_sigmoid_real(sum) (1.0f / (1.0f + FANN_EXP((-2.0f) * sum)))
#define fann_sigmoid_derive(steepness, value) (((2.0f * steepness) * value) * (1.0f - value))
#define fann_sigmoid_symmetric_real(sum) ((2.0f / (1.0f + FANN_EXP((-2.0f) * sum))) - 1.0f)
#define fann_sigmoid_symmetric_derive(steepness, value) (steepness * (1.0f - (value * value)))
#define fann_gaussian_real(sum) FANN_EXP((-sum) * sum)
#define fann_gaussian_derive(steepness, value, sum) (((((-2.0f) * sum) * value) * steepness) * steepness)
#define fann_gaussian_symmetric_real(sum) ((FANN_EXP((-sum) * sum) * 2.0f) - 1.0f)
#define fann_gaussian_symmetric_derive(steepness, value, sum) (((((-2.0f) * sum) * (value + 1.0f)) * steepness) * steepness)
#define fann_elliot_real(sum) ((((sum) / 2.0f) / (1.0f + fann_abs(sum))) + 0.5f)
#define fann_elliot_derive(steepness, value, sum) ((steepness * 1.0f) / ((2.0f * (1.0f + fann_abs(sum))) * (1.0f + fann_abs(sum))))
#define fann_elliot_symmetric_real(sum) ((sum) / (1.0f + fann_abs(sum)))
#define fann_elliot_symmetric_derive(steepness, value, sum) ((steepness * 1.0f) / ((1.0f + fann_abs(sum)) * (1.0f + fann_abs(sum))))
#define fann_sin_symmetric_real(sum) FANN_SIN(sum)
#define fann_sin_symmetric_derive(steepness, sum) (steepness * cos(steepness * sum))
#define fann_cos_symmetric_real(sum) FANN_COS(sum)
#define fann_cos_symmetric_derive(steepness, sum) (steepness * (-sin(steepness * sum)))
#define fann_sin_real(sum) ((FANN_SIN(sum) / 2.0f) + 0.5f)
#define fann_sin_derive(steepness, sum) ((steepness * cos(steepness * sum)) / 2.0f)
#define fann_cos_real(sum) ((FANN_COS(sum) / 2.0f) + 0.5f)
#define fann_cos_derive(steepness, sum) ((steepness * (-sin(steepness * sum))) / 2.0f)

#macro fann_activation_switch(activation_function, value, result) 
	 select case (activation_function) { 
	 	case FANN_LINEAR: result = cast(fann_type,value)
	 	case FANN_LINEAR_PIECE: result = cast(fann_type,((value < 0) ? 0 : (value > 1) ? 1 : value))
	 	case FANN_LINEAR_PIECE_SYMMETRIC: result = cast(fann_type,((value < -1) ? -1 : (value > 1) ? 1 : value))
	 	case FANN_SIGMOID: result = cast(fann_type,fann_sigmoid_real(value))
	 	case FANN_SIGMOID_SYMMETRIC: result = cast(fann_type,fann_sigmoid_symmetric_real(value))
	 	case FANN_SIGMOID_SYMMETRIC_STEPWISE
	 	 result = cast(fann_type,fann_stepwise( (cast(fann_type,-2.64665293693542480469e+00)), _
	 	 (cast(fann_type,-1.47221934795379638672e+00)), (cast(fann_type,-5.49306154251098632812e-01)), _
	 	 (cast(fann_type,5.49306154251098632812e-01)), (cast(fann_type,1.47221934795379638672e+00)), _
	 	 (cast(fann_type,2.64665293693542480469e+00)), (cast(fann_type,-9.90000009536743164062e-01)), _
	 	 (cast(fann_type,-8.99999976158142089844e-01)), (cast(fann_type,-5.00000000000000000000e-01)), _
	 	 (cast(fann_type,5.00000000000000000000e-01)), (cast(fann_type,8.99999976158142089844e-01)), _
	 	 (cast(fann_type,9.90000009536743164062e-01)), -1, 1, value))
	 	 case FANN_SIGMOID_STEPWISE
	 	 result = cast(fann_type,fann_stepwise( (cast(fann_type-2.64665246009826660156e+00)), _
	 	 (cast(fann_type,-1.47221946716308593750e+00)), (cast(fann_type,-5.49306154251098632812e-01)), _
	 	 (cast(fann_type, 5.49306154251098632812e-01)), (cast(fann_type,1.47221934795379638672e+00)), _
	 	 (cast(fann_type, 2.64665293693542480469e+00)), (cast(fann_type,4.99999988824129104614e-03)), _
	 	 (cast(fann_type, 5.00000007450580596924e-02)), (cast(fann_type,2.50000000000000000000e-01)), _
	 	 (cast(fann_type, 7.50000000000000000000e-01)), (cast(fann_type,9.49999988079071044922e-01)), _
	 	 (cast(fann_type, 9.95000004768371582031e-01)), 0, 1, value))
	 	 case FANN_THRESHOLD: result = cast(fann_type,(iif((value < 0) , 0 , 1)))
	 	 case FANN_THRESHOLD_SYMMETRIC: result = cast(fann_type,iif((value < 0) , -1 , 1))
	 	 case FANN_GAUSSIAN: result = cast(fann_type,fann_gaussian_real(value))
	 	 case FANN_GAUSSIAN_SYMMETRIC: result = cast(fann_type,fann_gaussian_symmetric_real(value))
	 	 case FANN_ELLIOT: result = cast(fann_type,fann_elliot_real(value))
	 	 case FANN_ELLIOT_SYMMETRIC: result = cast(fann_type,fann_elliot_symmetric_real(value))
	 	 case FANN_SIN_SYMMETRIC: result = cast(fann_type,fann_sin_symmetric_real(value))
	 	 case FANN_COS_SYMMETRIC: result = cast(fann_type,fann_cos_symmetric_real(value))
	 	 case FANN_SIN: result = cast(fann_type,fann_sin_real(value))
	 	 case FANN_COS: result = cast(fann_type,fann_cos_real(value))
	 	 case FANN_GAUSSIAN_STEPWISE: result = 0
	 End Select
#EndMacro
#define __fann_data_h__

type fann_train_enum as long
enum
	FANN_TRAIN_INCREMENTAL = 0
	FANN_TRAIN_BATCH
	FANN_TRAIN_RPROP
	FANN_TRAIN_QUICKPROP
	FANN_TRAIN_SARPROP
end enum

static shared FANN_TRAIN_NAMES(0 to ...) as const zstring const ptr = { @"FANN_TRAIN_INCREMENTAL", @"FANN_TRAIN_BATCH", _
 @"FANN_TRAIN_RPROP", @"FANN_TRAIN_QUICKPROP", @"FANN_TRAIN_SARPROP" }

type fann_activationfunc_enum as long
enum
	FANN_LINEAR = 0
	FANN_THRESHOLD
	FANN_THRESHOLD_SYMMETRIC
	FANN_SIGMOID
	FANN_SIGMOID_STEPWISE
	FANN_SIGMOID_SYMMETRIC
	FANN_SIGMOID_SYMMETRIC_STEPWISE
	FANN_GAUSSIAN
	FANN_GAUSSIAN_SYMMETRIC
	FANN_GAUSSIAN_STEPWISE
	FANN_ELLIOT
	FANN_ELLIOT_SYMMETRIC
	FANN_LINEAR_PIECE
	FANN_LINEAR_PIECE_SYMMETRIC
	FANN_SIN_SYMMETRIC
	FANN_COS_SYMMETRIC
	FANN_SIN
	FANN_COS
end enum

static shared FANN_ACTIVATIONFUNC_NAMES(0 to ...) as const zstring const ptr = { @"FANN_LINEAR", @"FANN_THRESHOLD", @"FANN_THRESHOLD_SYMMETRIC", @"FANN_SIGMOID", _
@"FANN_SIGMOID_STEPWISE", @"FANN_SIGMOID_SYMMETRIC", @"FANN_SIGMOID_SYMMETRIC_STEPWISE", @"FANN_GAUSSIAN", @"FANN_GAUSSIAN_SYMMETRIC", _
@"FANN_GAUSSIAN_STEPWISE", @"FANN_ELLIOT", @"FANN_ELLIOT_SYMMETRIC", @"FANN_LINEAR_PIECE", @"FANN_LINEAR_PIECE_SYMMETRIC", @"FANN_SIN_SYMMETRIC", _
@"FANN_COS_SYMMETRIC", @"FANN_SIN", @"FANN_COS" }

type fann_errorfunc_enum as long
enum
	FANN_ERRORFUNC_LINEAR = 0
	FANN_ERRORFUNC_TANH
end enum

static shared FANN_ERRORFUNC_NAMES(0 to ...) as const zstring const ptr = {@"FANN_ERRORFUNC_LINEAR", @"FANN_ERRORFUNC_TANH"}

type fann_stopfunc_enum as long
enum
	FANN_STOPFUNC_MSE = 0
	FANN_STOPFUNC_BIT
end enum

static shared FANN_STOPFUNC_NAMES(0 to ...) as const zstring const ptr = {@"FANN_STOPFUNC_MSE", @"FANN_STOPFUNC_BIT"}

type fann_nettype_enum as long
enum
	FANN_NETTYPE_LAYER = 0
	FANN_NETTYPE_SHORTCUT
end enum

static shared FANN_NETTYPE_NAMES(0 to ...) as const zstring const ptr = {@"FANN_NETTYPE_LAYER", @"FANN_NETTYPE_SHORTCUT"}
type fann as fann_
type fann_train_data as fann_train_data_
type fann_callback_type as function cdecl (byval ann as fann ptr, byval train as fann_train_data ptr, byval max_epochs as ulong, byval epochs_between_reports as ulong, byval desired_error as single, byval epochs as ulong) as long

type fann_neuron field = 1
	first_con as ulong
	last_con as ulong
	sum as fann_type
	value as fann_type
	activation_steepness as fann_type
	activation_function as fann_activationfunc_enum
end type

type fann_layer
	first_neuron as fann_neuron ptr
	last_neuron as fann_neuron ptr
end type

type fann_error_
	errno_f as fann_errno_enum
	error_log as FILE ptr
	errstr as zstring ptr
end type

type fann_
	errno_f as fann_errno_enum
	error_log as FILE ptr
	errstr as zstring ptr
	learning_rate as single
	learning_momentum as single
	connection_rate as single
	network_type as fann_nettype_enum
	first_layer as fann_layer ptr
	last_layer as fann_layer ptr
	total_neurons as ulong
	num_input as ulong
	num_output as ulong
	weights as fann_type ptr
	connections as fann_neuron ptr ptr
	train_errors as fann_type ptr
	training_algorithm as fann_train_enum
	total_connections as ulong
	output as fann_type ptr
	num_MSE as ulong
	MSE_value as single
	num_bit_fail as ulong
	bit_fail_limit as fann_type
	train_error_function as fann_errorfunc_enum
	train_stop_function as fann_stopfunc_enum
	callback as fann_callback_type
	user_data as any ptr
	cascade_output_change_fraction as single
	cascade_output_stagnation_epochs as ulong
	cascade_candidate_change_fraction as single
	cascade_candidate_stagnation_epochs as ulong
	cascade_best_candidate as ulong
	cascade_candidate_limit as fann_type
	cascade_weight_multiplier as fann_type
	cascade_max_out_epochs as ulong
	cascade_max_cand_epochs as ulong
	cascade_min_out_epochs as ulong
	cascade_min_cand_epochs as ulong
	cascade_activation_functions as fann_activationfunc_enum ptr
	cascade_activation_functions_count as ulong
	cascade_activation_steepnesses as fann_type ptr
	cascade_activation_steepnesses_count as ulong
	cascade_num_candidate_groups as ulong
	cascade_candidate_scores as fann_type ptr
	total_neurons_allocated as ulong
	total_connections_allocated as ulong
	quickprop_decay as single
	quickprop_mu as single
	rprop_increase_factor as single
	rprop_decrease_factor as single
	rprop_delta_min as single
	rprop_delta_max as single
	rprop_delta_zero as single
	sarprop_weight_decay_shift as single
	sarprop_step_error_threshold_factor as single
	sarprop_step_error_shift as single
	sarprop_temperature as single
	sarprop_epoch as ulong
	train_slopes as fann_type ptr
	prev_steps as fann_type ptr
	prev_train_slopes as fann_type ptr
	prev_weights_deltas as fann_type ptr
	scale_mean_in as single ptr
	scale_deviation_in as single ptr
	scale_new_min_in as single ptr
	scale_factor_in as single ptr
	scale_mean_out as single ptr
	scale_deviation_out as single ptr
	scale_new_min_out as single ptr
	scale_factor_out as single ptr
end type

type fann_connection
	from_neuron as ulong
	to_neuron as ulong
	weight as fann_type
end type

#define __fann_internal_h__
#define FANN_FIX_VERSION "FANN_FIX_2.0"
#define FANN_FLO_VERSION "FANN_FLO_2.1"
#define FANN_CONF_VERSION FANN_FLO_VERSION

#define FANN_GET(_type, _name) function  FANN_API fann_get_##name cdecl (ann as fann ptr) as _Type : return ann->_name : end function
#define FANN_SET(_type, _name) sub fann_set_##name cdecl (ann as fann ptr, value as _type) : ann->_name = value : end sub
#define FANN_GET_SET(_type, _name) FANN_GET(_type, _name) : FANN_SET(_type, _name)

declare function fann_allocate_structure(byval num_layers as ulong) as fann ptr
declare sub fann_allocate_neurons(byval ann as fann ptr)
declare sub fann_allocate_connections(byval ann as fann ptr)
declare function fann_save_internal(byval ann as fann ptr, byval configuration_file as const zstring ptr, byval save_as_fixed as ulong) as long
declare function fann_save_internal_fd(byval ann as fann ptr, byval conf as FILE ptr, byval configuration_file as const zstring ptr, byval save_as_fixed as ulong) as long
declare function fann_save_train_internal(byval data as fann_train_data ptr, byval filename as const zstring ptr, byval save_as_fixed as ulong, byval decimal_point as ulong) as long
declare function fann_save_train_internal_fd(byval data as fann_train_data ptr, byval file as FILE ptr, byval filename as const zstring ptr, byval save_as_fixed as ulong, byval decimal_point as ulong) as long
declare sub fann_update_stepwise(byval ann as fann ptr)
declare sub fann_seed_rand()
declare sub fann_error(byval errdat as fann_error ptr, byval errno_f as const fann_errno_enum, ...)
declare sub fann_init_error_data(byval errdat as fann_error ptr)
declare function fann_create_from_fd(byval conf as FILE ptr, byval configuration_file as const zstring ptr) as fann ptr
declare function fann_read_train_from_fd(byval file as FILE ptr, byval filename as const zstring ptr) as fann_train_data ptr
declare sub fann_compute_MSE(byval ann as fann ptr, byval desired_output as fann_type ptr)
declare sub fann_update_output_weights(byval ann as fann ptr)
declare sub fann_backpropagate_MSE(byval ann as fann ptr)
declare sub fann_update_weights(byval ann as fann ptr)
declare sub fann_update_slopes_batch(byval ann as fann ptr, byval layer_begin as fann_layer ptr, byval layer_end as fann_layer ptr)
declare sub fann_update_weights_quickprop(byval ann as fann ptr, byval num_data as ulong, byval first_weight as ulong, byval past_end as ulong)
declare sub fann_update_weights_batch(byval ann as fann ptr, byval num_data as ulong, byval first_weight as ulong, byval past_end as ulong)
declare sub fann_update_weights_irpropm(byval ann as fann ptr, byval first_weight as ulong, byval past_end as ulong)
declare sub fann_update_weights_sarprop(byval ann as fann ptr, byval epoch as ulong, byval first_weight as ulong, byval past_end as ulong)
declare sub fann_clear_train_arrays(byval ann as fann ptr)
declare function fann_activation(byval ann as fann ptr, byval activation_function as ulong, byval steepness as fann_type, byval value as fann_type) as fann_type
declare function fann_activation_derived(byval activation_function as ulong, byval steepness as fann_type, byval value as fann_type, byval sum as fann_type) as fann_type
declare function fann_desired_error_reached(byval ann as fann ptr, byval desired_error as single) as long
declare function fann_train_outputs(byval ann as fann ptr, byval data as fann_train_data ptr, byval desired_error as single) as long
declare function fann_train_outputs_epoch(byval ann as fann ptr, byval data as fann_train_data ptr) as single
declare function fann_train_candidates(byval ann as fann ptr, byval data as fann_train_data ptr) as long
declare function fann_train_candidates_epoch(byval ann as fann ptr, byval data as fann_train_data ptr) as fann_type
declare sub fann_install_candidate(byval ann as fann ptr)
declare function fann_check_input_output_sizes(byval ann as fann ptr, byval data as fann_train_data ptr) as long
declare function fann_initialize_candidates(byval ann as fann ptr) as long
declare sub fann_set_shortcut_connections(byval ann as fann ptr)
declare function fann_allocate_scale(byval ann as fann ptr) as long
declare sub fann_scale_data_to_range(byval data as fann_type ptr ptr, byval num_data as ulong, byval num_elem as ulong, byval old_min as fann_type, byval old_max as fann_type, byval new_min as fann_type, byval new_max as fann_type)

#define fann_max(x, y) iif((x) > (y), (x), (y))
#define fann_min(x, y) iif((x) < (y), (x), (y))
#macro fann_safe_free(x)
	if x then
		free(x)
		x = NULL
	end if
#endmacro
#define fann_clip(x, lo, hi) iif((x) < (lo), (lo), iif((x) > (hi), (hi), (x)))
#define fann_exp2(x) exp(0.69314718055994530942 * (x))
#define fann_rand(min_value, max_value) (csng(min_value) + (((csng(max_value) - csng(min_value)) * rand()) / (RAND_MAX + 1.0f)))
#define fann_abs(value) iif((value) > 0, (value), -(value))
#define fann_mult(x, y) (x * y)
#define fann_div(x, y) (x / y)
#define fann_random_weight() fann_rand(-0.1f, 0.1f)
#define fann_random_bias_weight() fann_rand(-0.1f, 0.1f)
#define __fann_train_h__

type fann_train_data_
	errno_f as fann_errno_enum
	error_log as FILE ptr
	errstr as zstring ptr
	num_data as ulong
	num_input as ulong
	num_output as ulong
	input as fann_type ptr ptr
	output as fann_type ptr ptr
end type

declare sub fann_train(byval ann as fann ptr, byval input as fann_type ptr, byval desired_output as fann_type ptr)
declare function fann_test(byval ann as fann ptr, byval input as fann_type ptr, byval desired_output as fann_type ptr) as fann_type ptr
declare function fann_get_MSE(byval ann as fann ptr) as single
declare function fann_get_bit_fail(byval ann as fann ptr) as ulong
declare sub fann_reset_MSE(byval ann as fann ptr)
declare sub fann_train_on_data(byval ann as fann ptr, byval data as fann_train_data ptr, byval max_epochs as ulong, byval epochs_between_reports as ulong, byval desired_error as single)
declare sub fann_train_on_file(byval ann as fann ptr, byval filename as const zstring ptr, byval max_epochs as ulong, byval epochs_between_reports as ulong, byval desired_error as single)
declare function fann_train_epoch(byval ann as fann ptr, byval data as fann_train_data ptr) as single
declare function fann_test_data(byval ann as fann ptr, byval data as fann_train_data ptr) as single
declare function fann_read_train_from_file(byval filename as const zstring ptr) as fann_train_data ptr
declare function fann_create_train(byval num_data as ulong, byval num_input as ulong, byval num_output as ulong) as fann_train_data ptr
declare function fann_create_train_pointer_array(byval num_data as ulong, byval num_input as ulong, byval input as fann_type ptr ptr, byval num_output as ulong, byval output as fann_type ptr ptr) as fann_train_data ptr
declare function fann_create_train_array(byval num_data as ulong, byval num_input as ulong, byval input as fann_type ptr, byval num_output as ulong, byval output as fann_type ptr) as fann_train_data ptr
declare function fann_create_train_from_callback(byval num_data as ulong, byval num_input as ulong, byval num_output as ulong, byval user_function as sub(byval as ulong, byval as ulong, byval as ulong, byval as fann_type ptr, byval as fann_type ptr)) as fann_train_data ptr
declare sub fann_destroy_train(byval train_data as fann_train_data ptr)
declare function fann_get_train_input(byval data as fann_train_data ptr, byval position as ulong) as fann_type ptr
declare function fann_get_train_output(byval data as fann_train_data ptr, byval position as ulong) as fann_type ptr
declare sub fann_shuffle_train_data(byval train_data as fann_train_data ptr)
declare function fann_get_min_train_input(byval train_data as fann_train_data ptr) as fann_type
declare function fann_get_max_train_input(byval train_data as fann_train_data ptr) as fann_type
declare function fann_get_min_train_output(byval train_data as fann_train_data ptr) as fann_type
declare function fann_get_max_train_output(byval train_data as fann_train_data ptr) as fann_type
declare sub fann_scale_train(byval ann as fann ptr, byval data as fann_train_data ptr)
declare sub fann_descale_train(byval ann as fann ptr, byval data as fann_train_data ptr)
declare function fann_set_input_scaling_params(byval ann as fann ptr, byval data as const fann_train_data ptr, byval new_input_min as single, byval new_input_max as single) as long
declare function fann_set_output_scaling_params(byval ann as fann ptr, byval data as const fann_train_data ptr, byval new_output_min as single, byval new_output_max as single) as long
declare function fann_set_scaling_params(byval ann as fann ptr, byval data as const fann_train_data ptr, byval new_input_min as single, byval new_input_max as single, byval new_output_min as single, byval new_output_max as single) as long
declare function fann_clear_scaling_params(byval ann as fann ptr) as long
declare sub fann_scale_input(byval ann as fann ptr, byval input_vector as fann_type ptr)
declare sub fann_scale_output(byval ann as fann ptr, byval output_vector as fann_type ptr)
declare sub fann_descale_input(byval ann as fann ptr, byval input_vector as fann_type ptr)
declare sub fann_descale_output(byval ann as fann ptr, byval output_vector as fann_type ptr)
declare sub fann_scale_input_train_data(byval train_data as fann_train_data ptr, byval new_min as fann_type, byval new_max as fann_type)
declare sub fann_scale_output_train_data(byval train_data as fann_train_data ptr, byval new_min as fann_type, byval new_max as fann_type)
declare sub fann_scale_train_data(byval train_data as fann_train_data ptr, byval new_min as fann_type, byval new_max as fann_type)
declare function fann_merge_train_data(byval data1 as fann_train_data ptr, byval data2 as fann_train_data ptr) as fann_train_data ptr
declare function fann_duplicate_train_data(byval data as fann_train_data ptr) as fann_train_data ptr
declare function fann_subset_train_data(byval data as fann_train_data ptr, byval pos as ulong, byval length as ulong) as fann_train_data ptr
declare function fann_length_train_data(byval data as fann_train_data ptr) as ulong
declare function fann_num_input_train_data(byval data as fann_train_data ptr) as ulong
declare function fann_num_output_train_data(byval data as fann_train_data ptr) as ulong
declare function fann_save_train(byval data as fann_train_data ptr, byval filename as const zstring ptr) as long
declare function fann_save_train_to_fixed(byval data as fann_train_data ptr, byval filename as const zstring ptr, byval decimal_point as ulong) as long
declare function fann_get_training_algorithm(byval ann as fann ptr) as fann_train_enum
declare sub fann_set_training_algorithm(byval ann as fann ptr, byval training_algorithm as fann_train_enum)
declare function fann_get_learning_rate(byval ann as fann ptr) as single
declare sub fann_set_learning_rate(byval ann as fann ptr, byval learning_rate as single)
declare function fann_get_learning_momentum(byval ann as fann ptr) as single
declare sub fann_set_learning_momentum(byval ann as fann ptr, byval learning_momentum as single)
declare function fann_get_activation_function(byval ann as fann ptr, byval layer as long, byval neuron as long) as fann_activationfunc_enum
declare sub fann_set_activation_function(byval ann as fann ptr, byval activation_function as fann_activationfunc_enum, byval layer as long, byval neuron as long)
declare sub fann_set_activation_function_layer(byval ann as fann ptr, byval activation_function as fann_activationfunc_enum, byval layer as long)
declare sub fann_set_activation_function_hidden(byval ann as fann ptr, byval activation_function as fann_activationfunc_enum)
declare sub fann_set_activation_function_output(byval ann as fann ptr, byval activation_function as fann_activationfunc_enum)
declare function fann_get_activation_steepness(byval ann as fann ptr, byval layer as long, byval neuron as long) as fann_type
declare sub fann_set_activation_steepness(byval ann as fann ptr, byval steepness as fann_type, byval layer as long, byval neuron as long)
declare sub fann_set_activation_steepness_layer(byval ann as fann ptr, byval steepness as fann_type, byval layer as long)
declare sub fann_set_activation_steepness_hidden(byval ann as fann ptr, byval steepness as fann_type)
declare sub fann_set_activation_steepness_output(byval ann as fann ptr, byval steepness as fann_type)
declare function fann_get_train_error_function(byval ann as fann ptr) as fann_errorfunc_enum
declare sub fann_set_train_error_function(byval ann as fann ptr, byval train_error_function as fann_errorfunc_enum)
declare function fann_get_train_stop_function(byval ann as fann ptr) as fann_stopfunc_enum
declare sub fann_set_train_stop_function(byval ann as fann ptr, byval train_stop_function as fann_stopfunc_enum)
declare function fann_get_bit_fail_limit(byval ann as fann ptr) as fann_type
declare sub fann_set_bit_fail_limit(byval ann as fann ptr, byval bit_fail_limit as fann_type)
declare sub fann_set_callback(byval ann as fann ptr, byval callback as fann_callback_type)
declare function fann_get_quickprop_decay(byval ann as fann ptr) as single
declare sub fann_set_quickprop_decay(byval ann as fann ptr, byval quickprop_decay as single)
declare function fann_get_quickprop_mu(byval ann as fann ptr) as single
declare sub fann_set_quickprop_mu(byval ann as fann ptr, byval quickprop_mu as single)
declare function fann_get_rprop_increase_factor(byval ann as fann ptr) as single
declare sub fann_set_rprop_increase_factor(byval ann as fann ptr, byval rprop_increase_factor as single)
declare function fann_get_rprop_decrease_factor(byval ann as fann ptr) as single
declare sub fann_set_rprop_decrease_factor(byval ann as fann ptr, byval rprop_decrease_factor as single)
declare function fann_get_rprop_delta_min(byval ann as fann ptr) as single
declare sub fann_set_rprop_delta_min(byval ann as fann ptr, byval rprop_delta_min as single)
declare function fann_get_rprop_delta_max(byval ann as fann ptr) as single
declare sub fann_set_rprop_delta_max(byval ann as fann ptr, byval rprop_delta_max as single)
declare function fann_get_rprop_delta_zero(byval ann as fann ptr) as single
declare sub fann_set_rprop_delta_zero(byval ann as fann ptr, byval rprop_delta_max as single)
declare function fann_get_sarprop_weight_decay_shift(byval ann as fann ptr) as single
declare sub fann_set_sarprop_weight_decay_shift(byval ann as fann ptr, byval sarprop_weight_decay_shift as single)
declare function fann_get_sarprop_step_error_threshold_factor(byval ann as fann ptr) as single
declare sub fann_set_sarprop_step_error_threshold_factor(byval ann as fann ptr, byval sarprop_step_error_threshold_factor as single)
declare function fann_get_sarprop_step_error_shift(byval ann as fann ptr) as single
declare sub fann_set_sarprop_step_error_shift(byval ann as fann ptr, byval sarprop_step_error_shift as single)
declare function fann_get_sarprop_temperature(byval ann as fann ptr) as single
declare sub fann_set_sarprop_temperature(byval ann as fann ptr, byval sarprop_temperature as single)
#define __fann_cascade_h__
declare sub fann_cascadetrain_on_data(byval ann as fann ptr, byval data as fann_train_data ptr, byval max_neurons as ulong, byval neurons_between_reports as ulong, byval desired_error as single)
declare sub fann_cascadetrain_on_file(byval ann as fann ptr, byval filename as const zstring ptr, byval max_neurons as ulong, byval neurons_between_reports as ulong, byval desired_error as single)
declare function fann_get_cascade_output_change_fraction(byval ann as fann ptr) as single
declare sub fann_set_cascade_output_change_fraction(byval ann as fann ptr, byval cascade_output_change_fraction as single)
declare function fann_get_cascade_output_stagnation_epochs(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_output_stagnation_epochs(byval ann as fann ptr, byval cascade_output_stagnation_epochs as ulong)
declare function fann_get_cascade_candidate_change_fraction(byval ann as fann ptr) as single
declare sub fann_set_cascade_candidate_change_fraction(byval ann as fann ptr, byval cascade_candidate_change_fraction as single)
declare function fann_get_cascade_candidate_stagnation_epochs(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_candidate_stagnation_epochs(byval ann as fann ptr, byval cascade_candidate_stagnation_epochs as ulong)
declare function fann_get_cascade_weight_multiplier(byval ann as fann ptr) as fann_type
declare sub fann_set_cascade_weight_multiplier(byval ann as fann ptr, byval cascade_weight_multiplier as fann_type)
declare function fann_get_cascade_candidate_limit(byval ann as fann ptr) as fann_type
declare sub fann_set_cascade_candidate_limit(byval ann as fann ptr, byval cascade_candidate_limit as fann_type)
declare function fann_get_cascade_max_out_epochs(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_max_out_epochs(byval ann as fann ptr, byval cascade_max_out_epochs as ulong)
declare function fann_get_cascade_min_out_epochs(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_min_out_epochs(byval ann as fann ptr, byval cascade_min_out_epochs as ulong)
declare function fann_get_cascade_max_cand_epochs(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_max_cand_epochs(byval ann as fann ptr, byval cascade_max_cand_epochs as ulong)
declare function fann_get_cascade_min_cand_epochs(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_min_cand_epochs(byval ann as fann ptr, byval cascade_min_cand_epochs as ulong)
declare function fann_get_cascade_num_candidates(byval ann as fann ptr) as ulong
declare function fann_get_cascade_activation_functions_count(byval ann as fann ptr) as ulong
declare function fann_get_cascade_activation_functions(byval ann as fann ptr) as fann_activationfunc_enum ptr
declare sub fann_set_cascade_activation_functions(byval ann as fann ptr, byval cascade_activation_functions as fann_activationfunc_enum ptr, byval cascade_activation_functions_count as ulong)
declare function fann_get_cascade_activation_steepnesses_count(byval ann as fann ptr) as ulong
declare function fann_get_cascade_activation_steepnesses(byval ann as fann ptr) as fann_type ptr
declare sub fann_set_cascade_activation_steepnesses(byval ann as fann ptr, byval cascade_activation_steepnesses as fann_type ptr, byval cascade_activation_steepnesses_count as ulong)
declare function fann_get_cascade_num_candidate_groups(byval ann as fann ptr) as ulong
declare sub fann_set_cascade_num_candidate_groups(byval ann as fann ptr, byval cascade_num_candidate_groups as ulong)
#define __fann_io_h__
declare function fann_create_from_file(byval configuration_file as const zstring ptr) as fann ptr
declare function fann_save(byval ann as fann ptr, byval configuration_file as const zstring ptr) as long
declare function fann_save_to_fixed(byval ann as fann ptr, byval configuration_file as const zstring ptr) as long
declare function fann_create_standard(byval num_layers as ulong, ...) as fann ptr
declare function fann_create_standard_array(byval num_layers as ulong, byval layers as const ulong ptr) as fann ptr
declare function fann_create_sparse(byval connection_rate as single, byval num_layers as ulong, ...) as fann ptr
declare function fann_create_sparse_array(byval connection_rate as single, byval num_layers as ulong, byval layers as const ulong ptr) as fann ptr
declare function fann_create_shortcut(byval num_layers as ulong, ...) as fann ptr
declare function fann_create_shortcut_array(byval num_layers as ulong, byval layers as const ulong ptr) as fann ptr
declare sub fann_destroy(byval ann as fann ptr)
declare function fann_copy(byval ann as fann ptr) as fann ptr
declare function fann_run(byval ann as fann ptr, byval input as fann_type ptr) as fann_type ptr
declare sub fann_randomize_weights(byval ann as fann ptr, byval min_weight as fann_type, byval max_weight as fann_type)
declare sub fann_init_weights(byval ann as fann ptr, byval train_data as fann_train_data ptr)
declare sub fann_print_connections(byval ann as fann ptr)
declare sub fann_print_parameters(byval ann as fann ptr)
declare function fann_get_num_input(byval ann as fann ptr) as ulong
declare function fann_get_num_output(byval ann as fann ptr) as ulong
declare function fann_get_total_neurons(byval ann as fann ptr) as ulong
declare function fann_get_total_connections(byval ann as fann ptr) as ulong
declare function fann_get_network_type(byval ann as fann ptr) as fann_nettype_enum
declare function fann_get_connection_rate(byval ann as fann ptr) as single
declare function fann_get_num_layers(byval ann as fann ptr) as ulong
declare sub fann_get_layer_array(byval ann as fann ptr, byval layers as ulong ptr)
declare sub fann_get_bias_array(byval ann as fann ptr, byval bias as ulong ptr)
declare sub fann_get_connection_array(byval ann as fann ptr, byval connections as fann_connection ptr)
declare sub fann_set_weight_array(byval ann as fann ptr, byval connections as fann_connection ptr, byval num_connections as ulong)
declare sub fann_set_weight(byval ann as fann ptr, byval from_neuron as ulong, byval to_neuron as ulong, byval weight as fann_type)
declare sub fann_get_weights(byval ann as fann ptr, byval weights as fann_type ptr)
declare sub fann_set_weights(byval ann as fann ptr, byval weights as fann_type ptr)
declare sub fann_set_user_data(byval ann as fann ptr, byval user_data as any ptr)
declare function fann_get_user_data(byval ann as fann ptr) as any ptr
declare sub fann_disable_seed_rand()
declare sub fann_enable_seed_rand()

end extern
