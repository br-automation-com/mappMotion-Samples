
TYPE
	StateOpenCloseEnum : 
		(
		STATE_OPEN_CLOSE,
		STATE_STATUS
		);
	AxisBrakeType : 	STRUCT 
		CmdClose : BOOL;
		CmdOpen : BOOL;
		CmdSetPar : BOOL;
		ParAxis : McAxisType;
		ParBrake : McAcpAxBrakeParType;
		StaBrake : McBrakeStatusEnum;
		ErrId : DINT;
	END_STRUCT;
END_TYPE
