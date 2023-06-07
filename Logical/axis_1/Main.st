
PROGRAM _INIT
	// --------------------------------------------------------------------------
	// Set standard motion parameters
	MpAxisBasicPar.Acceleration := 10000;
	MpAxisBasicPar.Deceleration := 10000;
	MpAxisBasicPar.Stop.Deceleration := 10000;
	MpAxisBasicPar.Velocity := 500;

	// --------------------------------------------------------------------------
	// Drive configuration
	AxisDriveCfg.MpLink := ADR(gAxis_1);			// MpLink for axis
 
END_PROGRAM

PROGRAM _CYCLIC
	
	// --------------------------------------------------------------------------
	// Call axis main function block
	MpAxisBasic_1.Enable := 1;
	MpAxisBasic_1.MpLink := ADR(gAxis_1);				
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicPar);	
	MpAxisBasic_1();

	// --------------------------------------------------------------------------
	// When drive configuration command was triggered
	// - Read configuration first to get all actual values
	// - Copy the actual values into the parameter structure to get a template
	// - Overwrite the parameters that need to be changed
	// - Trigger drive configuration write command
	// - Reset local write command when done
	IF EDGEPOS(cmdChangeDriveConfig) THEN
		AxisDriveCfg.CmdGetDrive := TRUE;
	END_IF
	IF EDGENEG(AxisDriveCfg.CmdGetDrive) THEN
		IF cmdChangeDriveConfig THEN
			brsmemcpy(ADR(AxisDriveCfg.ParDrive), ADR(AxisDriveCfg.StaDrive), SIZEOF(AxisDriveCfg.ParDrive));
			AxisConfigSample;					// Drive sample configuration
			AxisDriveCfg.CmdSetDrive := TRUE;	// Set changed parameters
		END_IF
	END_IF
	IF EDGENEG(AxisDriveCfg.CmdSetDrive) THEN
		cmdChangeDriveConfig := FALSE;			// Reset local command
	END_IF
	
	AxisDriveCfgAction;							// Call drive configuration action used for this drive
	
END_PROGRAM

PROGRAM _EXIT
	// Disable function block before updating task
	MpAxisBasic_1.Enable := 0;
	MpAxisBasic_1();
	 
END_PROGRAM

