
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 500;

	// --------------------------------------------------------------------------
	// Set brake parameters, disable brake restrictions
	AxisBrake.ParAxis := gAxis_1;
	AxisBrake.ParBrake.RestrictedBrakeControl := mcSWITCH_OFF;
	AxisBrake.CmdSetPar := TRUE;
	
	// --------------------------------------------------------------------------
	// Acknoledge encoder battery error
	mcACPAX_UDINT[1] := 1;
	AxisParId.ParAxis := gAxis_1;
	AxisParId.ParNum := 1;
	AxisParId.ParIds[1].ParID := 719;
	AxisParId.ParIds[1].VariableAddress := ADR(mcACPAX_UDINT);
	AxisParId.ParIds[1].DataType := mcACPAX_PARTYPE_UDINT;
	AxisParId.CmdSetPar := TRUE;
	
	// --------------------------------------------------------------------------
	// Motor configuration
	AxisMotorCfg.ParAxis := gAxis_1;
	AxisMotorCfg.ParMotorType := AX_MOTOR_TYPE_SYNCHRONOUS;
	Motor_8LVB13_B1030F300_00;
	 
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
	ParID;
	MotorCfg;
	
END_PROGRAM

PROGRAM _EXIT
	MpAxisBasic_1.Enable := 0;
	MpAxisBasic_1.MpLink := ADR(gAxis_1);
	MpAxisBasic_1();
	 
END_PROGRAM

