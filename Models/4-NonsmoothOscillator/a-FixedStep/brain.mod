: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Pedagogical model of a nonsmooth brain/body system.

NEURON {
	SUFFIX brain
	POINTER bPointer :: Pointer to 'b' in separate mod file
}

ASSIGNED { bPointer } :: Declare pointer variable

STATE { a } :: State variable

BREAKPOINT {
	SOLVE states METHOD derivimplicit :: Solve differential equation
	if ((a < 0) && (a * (1 - a) - bPointer < 0)) {
		a = 0
	}
}

INITIAL {
	a = 1.0 :: Set initial value of state variable.
}

DERIVATIVE states {
	a' = a * (1 - a) - bPointer
}
