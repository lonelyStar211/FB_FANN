'Fast Artificial Neural Network Library (fann)
'Copyright (C) 2003-2016 Steffen Nissen (steffen.fann@gmail.com)

'This library is free software; you can redistribute it and/or
'modify it under the terms of the GNU Lesser General Public
'License as published by the Free Software Foundation; either
'version 2.1 of the License, or (at your option) any later version.

'This library is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
'Lesser General Public License for more details.

'You should have received a copy of the GNU Lesser General Public
'License along with this library; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


#include "crt.bi"
#include "fann.bi"

#include "xor_test.bas"

function __main() as long
	
	__main2()
        
	dim as fann_type ptr calc_out
	dim as fann_type tinput(2-1)

    'struct	
	dim as fann ptr ann = fann_create_from_file("xor_float.net")

	tinput(0) = -1
	tinput(1) = 1
	calc_out = fann_run(ann, @tinput(0) )

	printf( !"xor test (%f,%f) -> %f\n", tinput(0), tinput(1), calc_out[0] )

	fann_destroy(ann)
  sleep
	return 0
end function

end __main()

