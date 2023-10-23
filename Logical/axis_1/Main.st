
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 200;

	// --------------------------------------------------------------------------
	// Preset ParID module
	AxisParId.MpLink := ADR(gAxis_1);								// MpLink for axis
	AxisParId.CmdUpdate := TRUE;
	
	// Acknowledge encoder battery error
	mcACPAX_UDINT := 1;												// Par ID value: Reset encoder error
	AxisParId.ParIds[1].Execute := mcACPAX_PARID_SET_ONCE;			// Execute write command once
	AxisParId.ParIds[1].ParID := 719;								// Encoder1: Encoder command
	AxisParId.ParIds[1].Variable := 'Axis_1:mcACPAX_UDINT';			// Variable as string

	// Read actual speed cyclic
	mcSPEED_ACTUAL := 0;											// Par ID value: Actual speed
	AxisParId.ParIds[2].Execute := mcACPAX_PARID_GET_CYCLIC;		// Execute write command cyclic
	AxisParId.ParIds[2].ParID := 251;								// Encoder1: Encoder command
	AxisParId.ParIds[2].Variable := 'Axis_1:mcSPEED_ACTUAL';		// Variable as string

	// Write maximum speed
	mcSPEED_MAX := 0;												// Par ID value: Maximum speed
	AxisParId.ParIds[3].Execute := mcACPAX_PARID_DONE;				// Dont execute command automatically
	AxisParId.ParIds[3].ParID := 687;								// Encoder1: Encoder command
	AxisParId.ParIds[3].Variable := 'Axis_1:mcSPEED_MAX';			// Variable as string

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

