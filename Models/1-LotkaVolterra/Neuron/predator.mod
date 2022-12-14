: Documentation: https://github.com/fietkiewicz/PointerBuilder
: Description: Lotka-Volterra (predator/prey) system.

NEURON {
	SUFFIX predator
	POINTER aPointer
}

PARAMETER {}

ASSIGNED { aPointer }

STATE { b }

BREAKPOINT {
	SOLVE states METHOD derivimplicit
}

INITIAL { b = 10 }

DERIVATIVE states {
	b' = 0.1 * aPointer * b - 0.4 * b
}
