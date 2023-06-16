
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 1000;

END_PROGRAM

PROGRAM _CYCLIC
	
	// --------------------------------------------------------------------------
	// Call axis main function block
	MpAxisBasic_1.Enable := 1;
	MpAxisBasic_1.MpLink := ADR(gAxis_2);
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicPar);
	MpAxisBasic_1();

END_PROGRAM

PROGRAM _EXIT
	// Disable function block before updating task
	MpAxisBasic_1.Enable := 0;
	MpAxisBasic_1();
	 
END_PROGRAM

