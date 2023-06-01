
ACTION AxisCommonAction:
	// --------------------------------------------------------------------------
	// Reboot PLC
	IF AxisCommon.CmdReboot THEN
		SYSreset(TRUE, SYSLIB_WARMSTART);
	END_IF

	// --------------------------------------------------------------------------
	// Avoid compiler warnings
	n;

END_ACTION
