
TYPE
	AxisCfgType : 	STRUCT 
		CmdSetAxis : BOOL;
		CmdGetAxis : BOOL;
		CmdReboot : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParAxis : McCfgAxType;
		StaAxis : McCfgAxType;
		ErrId : DINT;
	END_STRUCT;
	AxisCfgInternalType : 	STRUCT 
		ProcessConfig : MC_BR_ProcessConfig;
		GetHardwareInfo : MC_BR_GetHardwareInfo;
		State : AxisCfgStateEnum;
		Name : STRING[32];
		n : UINT;
	END_STRUCT;
	AxisCfgStateEnum : 
		(
		STATE_AXIS_CFG_WAIT,
		STATE_AXIS_CFG_PRE_SET,
		STATE_AXIS_CFG_READ,
		STATE_AXIS_CFG_WRITE
		);
END_TYPE
