
ACTION AxisCommonAction:
	// --------------------------------------------------------------------------
	// Reboot PLC
	IF AxisCommon.CmdReboot THEN
		SYSreset(TRUE, SYSLIB_WARMSTART);
	END_IF
	
END_ACTION
