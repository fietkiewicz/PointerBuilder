:: Documentation: https://github.com/fietkiewicz/PointerBuilder
:: Description: Muscle calcium dynamics.
:: Notes:
::   The model is adapted from the following paper:
::   Kim H. Linking Motoneuron PIC Location to Motor Function in Closed-Loop Motor Unit System Including Afferent
::   Feedback: A Computational Investigation. eNeuro. 2020 Apr 27;7(2)
::   On ModelDB: https://modeldb.science/266732

NEURON {
	POINT_PROCESS calcium

	RANGE k1, k2, k3, k4, k5, k6, k, k5i, k6i
	RANGE Umax, Rmax, tau1, tau2, R
	RANGE phi0, phi1, phi2, phi3, phi4
	RANGE c1, c2, c3, c4, c5
	RANGE AMinf, AMtau, SF_AM
	RANGE acm, alpha, alpha1, alpha2, alpha3, beta, gamma
	RANGE totalSpikes, axonDelay
}

PARAMETER {
	:: Calcium dynamics ::
	k1 = 3000		: M-1*ms-1
	k2 = 3			: ms-1
	k3 = 400		: M-1*ms-1
	k4 = 1			: ms-1
	k5i = 4e5		: M-1*ms-1
	k6i = 150		: ms-1
	k = 850			: M-1
	SF_AM = 5
	Rmax = 10		: ms-1
	Umax = 2000		: M-1*ms-1
	tau1 = 3			: ms
	tau2 = 25			: ms
	phi1 = 0.03
	phi2 = 1.23
	phi3 = 0.01
	phi4 = 1.08
	CS0 = 0.03     	:[M]
	B0 = 0.00043	:[M]
	T0 = 0.00007 	:[M]

	:: Muscle activation::
	c1 = 0.128
	c2 = 0.093
	c3 = 61.206
	c4 = -13.116
	c5 = 5.095
	alpha = 2
	alpha1 = 4.77
	alpha2 = 400
	alpha3 = 160
	beta = 0.47
	gamma = 0.001

	:: Neural input ::
	totalSpikes = 0
	axonDelay = 0.01
}

STATE {
	CaSR
	CaSRCS
	Ca
	CaB
	CaT
	AM
	A
	xm
}

ASSIGNED {
	R
	k5
	k6
	AMinf
	AMtau
	spike[1000]
	xmArray[2]
	vm
	acm
	dt
}

BREAKPOINT {
	CaR (CaSR, t)
	A = AM^alpha

	SOLVE state METHOD derivimplicit

	xmArray[0]=xmArray[1]
	xmArray[1]=xm

	vm = (xmArray[1]-xmArray[0])/(dt*10^-3)

	:: Isometric and isokinetic condition ::
	A = AM^alpha
}

DERIVATIVE state {
	rate (CaT, AM, t)
	CaSR' = -k1*CS0*CaSR + (k1*CaSR+k2)*CaSRCS - R + U(Ca)
	CaSRCS' = k1*CS0*CaSR - (k1*CaSR+k2)*CaSRCS
	Ca' = - k5*T0*Ca + (k5*Ca+k6)*CaT - k3*B0*Ca + (k3*Ca+k4)*CaB + R - U(Ca)
	CaB' = k3*B0*Ca - (k3*Ca+k4)*CaB
	CaT' = k5*T0*Ca - (k5*Ca+k6)*CaT
	AM' = (AMinf -AM)/AMtau
	A' = 0
}

FUNCTION U (x) {
	if (x >= 0) {U = Umax*(x^2*k^2/(1+x*k+x^2*k^2))^2}
	else {U = 0}
}

FUNCTION phi (x) {
	if (x <= -8) {phi = phi1*x + phi2}
	else {phi = phi3*x + phi4}
}

PROCEDURE CaR (CaSR (M), t (ms)) {
	LOCAL i
	R = 0
	FROM i = 0 TO totalSpikes - 1 {
		R = R + CaSR * Rmax * (1 - exp(-(t - spike[i]) / tau1)) * exp(-(t - spike[i]) / tau2)
	}
}

PROCEDURE rate (CaT (M), AM (M), t(ms)) {
	k5 = phi(-8)*k5i
	k6 = k6i/(1 + SF_AM*AM)
	AMinf = 0.5*(1+tanh(((CaT/T0)-c1)/c2))
	AMtau = c3/(cosh(((CaT/T0)-c4)/(2*c5)))
}

INITIAL {
	LOCAL i
	CaSR = 0.0025  		:[M]
	CaSRCS = 0			:[M]
	Ca = 1e-10			:[M]
	CaB = 0				:[M]
	CaT = 0				:[M]
	AM = 0				:[M]
	A = 0				:[M]
	xm = -8
	R = 0

	FROM i = 0 TO 999 {
		spike[i] = 0
	}
	FROM i = 0 TO 1 {
		xmArray[i] = 0
	}
	totalSpikes = 0
}

NET_RECEIVE (weight) {
	spike[totalSpikes] = t + axonDelay
	totalSpikes = totalSpikes + 1
}
