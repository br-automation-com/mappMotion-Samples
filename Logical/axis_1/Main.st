
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 500;

	// --------------------------------------------------------------------------
	// Motor configuration
	AxisMotorCfg.MpLink := ADR(gAxis_1);
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
	CommonAction;
	MotorCfgAction;
	
END_PROGRAM

PROGRAM _EXIT
	MpAxisBasic_1.Enable := 0;
	MpAxisBasic_1.MpLink := ADR(gAxis_1);
	MpAxisBasic_1();
	 
END_PROGRAM

