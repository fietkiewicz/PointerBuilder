: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Closed-loop model of feeding behavior in the sea hare Aplysia californica that incorporates biologically-motivated nonsmooth dynamics.

NEURON {
	SUFFIX body
	POINTER a0Pointer, a1Pointer, a2Pointer
}

PARAMETER {
	tau_m = 2.45  :: time constant for muscle activation
	umax = 1  :: peak muscle activation
	br = 0.4  :: grasper damping constant
	fsw = 0.0 :: seaweed force
}

ASSIGNED { a0Pointer a1Pointer a2Pointer c0 c1 w0 w1 grasperstate }

STATE { u0 u1 xr sw }

BREAKPOINT {
	SOLVE states METHOD euler
}

INITIAL {
	u0 = 0.747647099749367
	u1 = 0.246345045901938
	xr = 0.649984712236374
	sw = 0.0
}

DERIVATIVE states {
	u0' = ((a0Pointer + a1Pointer) * umax - u0) / tau_m
	u1' = ((a2Pointer * umax - u1) / tau_m)
	xr' = (fmusc(u0,u1,xr) + fsw) / br
	grasperstate = (a1Pointer + a2Pointer >= 0.5)
	sw' = -grasperstate * ((fmusc(u0,u1,xr) + fsw * grasperstate) / br)
}

FUNCTION phi(x) {
	:: cubic length-tension curve. Constant is 3*sqrt(3)/2
	phi = x - 2.598076211353316 * x * (x * x - 1)
}

FUNCTION fmusc(u0,u1,xr) {
	c0 = 1.0 :: Position of shortest length for I2
	c1 = 1.1 :: Position of shortest length for I3
	w0 = 2 ::  Maximal effective length of I2
	w1 = 1.1 :: Maximal effective length of I3
	fmusc = phi((c0 - xr) / w0) * u0 - phi((c1 - xr) / w1) * u1
}
