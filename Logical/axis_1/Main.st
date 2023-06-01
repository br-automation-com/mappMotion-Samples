
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 500;

	// --------------------------------------------------------------------------
	// Acknowledge encoder battery error
	mcACPAX_UDINT[1] := 1;											// Par ID value: Reset encoder error
	AxisParId.MpLink := ADR(gAxis_1);								// MpLink for axis
	AxisParId.ParNum := 1;											// Number of parameter IDs
	AxisParId.ParIds[1].ParID := 719;								// Encoder1: Encoder command
	AxisParId.ParIds[1].VariableAddress := ADR(mcACPAX_UDINT[1]);	// Pointer to predefined variable
	AxisParId.ParIds[1].DataType := mcACPAX_PARTYPE_UDINT;			// Data type of predefined variable
	AxisParId.CmdSetPar := TRUE;									// Execute command
	 
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
	ParIDAction;
	
END_PROGRAM

PROGRAM _EXIT
	// Disable function block before updating task
	MpAxisBasic_1.Enable := 0;
	MpAxisBasic_1();
	 
END_PROGRAM

