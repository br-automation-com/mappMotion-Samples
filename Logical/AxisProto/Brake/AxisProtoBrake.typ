
TYPE
	AxisBrakeType : 	STRUCT 
		CmdClose : BOOL;
		CmdOpen : BOOL;
		CmdSetPar : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParBrake : McAcpAxBrakeParType;
		StaBrake : McBrakeStatusEnum;
		ErrId : DINT;
	END_STRUCT;
	AxisBrakeStateEnum : 
		(
		STATE_BRAKE_WAIT,
		STATE_BRAKE_OPEN_CLOSE,
		STATE_BRAKE_STATUS
		);
END_TYPE
