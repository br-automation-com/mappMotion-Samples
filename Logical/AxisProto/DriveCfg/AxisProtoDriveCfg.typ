
TYPE
	AxisDriveCfgType : 	STRUCT 
		CmdSetDrive : BOOL;
		CmdGetDrive : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParDrive : McCfgAcpAxType;
		StaDrive : McCfgAcpAxType;
		ErrId : DINT;
	END_STRUCT;
	AxisDriveCfgStateEnum : 
		(
		STATE_DRIVE_CFG_WAIT,
		STATE_DRIVE_CFG_PRE_SET,
		STATE_DRIVE_CFG_READ,
		STATE_DRIVE_CFG_WRITE
		);
END_TYPE
