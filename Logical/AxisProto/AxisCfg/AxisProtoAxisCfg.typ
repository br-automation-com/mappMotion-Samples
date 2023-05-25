
TYPE
	AxisCfgType : 	STRUCT 
		CmdSetAxis : BOOL;
		CmdGetAxis : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParAxis : McCfgAxType;
		StaAxis : McCfgAxType;
		ErrId : DINT;
	END_STRUCT;
	AxisCfgStateEnum : 
		(
		STATE_AXIS_CFG_WAIT,
		STATE_AXIS_CFG_PRE_SET,
		STATE_AXIS_CFG_READ,
		STATE_AXIS_CFG_WRITE
		);
END_TYPE
