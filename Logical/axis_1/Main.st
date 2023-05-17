
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 500;

	// --------------------------------------------------------------------------
	// Set brake parameters, disable brake restrictions
	AxisBrake.MpLink := ADR(gAxis_1);
	AxisBrake.ParBrake.RestrictedBrakeControl := mcSWITCH_OFF;
	AxisBrake.CmdSetPar := TRUE;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// --------------------------------------------------------------------------
	// Call axis main function block
	MpAxisBasic_1.Enable := 1;
	MpAxisBasic_1.MpLink := ADR(gAxis_1);
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicPar);
	MpAxisBasic_1();

	// --------------------------------------------------------------------------
	// Call axis actions used for this drive
	Brake;
	
END_PROGRAM

PROGRAM _EXIT
	MpAxisBasic_1.Enable := 0;
	MpAxisBasic_1();
	 
END_PROGRAM

