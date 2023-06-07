
TYPE
	AxisDriveCfgType : 	STRUCT 
		CmdSetDrive : BOOL;
		CmdGetDrive : BOOL;
		CmdReboot : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParDrive : McCfgAcpAxType;
		StaDrive : McCfgAcpAxType;
		ErrId : DINT;
	END_STRUCT;
	AxisDriveCfgInternalType : 	STRUCT 
		ProcessConfig : MC_BR_ProcessConfig;
		GetHardwareInfo : MC_BR_GetHardwareInfo;
		State : AxisDriveCfgStateEnum;
		Address : STRING[64];
		Channel : STRING[64];
		n : UINT;
	END_STRUCT;
	AxisDriveCfgStateEnum : 
		(
		STATE_DRIVE_CFG_WAIT,
		STATE_DRIVE_CFG_PRE_SET,
		STATE_DRIVE_CFG_READ,
		STATE_DRIVE_CFG_WRITE
		);
END_TYPE
