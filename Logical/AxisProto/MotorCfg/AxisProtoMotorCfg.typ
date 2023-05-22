
TYPE
	AxisMotorCfgType : 	STRUCT 
		CmdSetMotor : BOOL;
		CmdGetMotor : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParMotorType : UDINT;
		ParMotorSynchronous : McCfgMotSynType;
		StaMotorSynchronous : McCfgMotSynType;
		ParMotorInduction : McCfgMotInductType;
		StaMotorInduction : McCfgMotInductType;
		ErrId : DINT;
	END_STRUCT;
	AxisMotorCfgTypeEnum : 
		(
		AX_MOTOR_TYPE_UNDEFINED,
		AX_MOTOR_TYPE_SYNCHRONOUS,
		AX_MOTOR_TYPE_INDUCTION
		);
	AxisMotorCfgStateEnum : 
		(
		STATE_MOTOR_CFG_WAIT,
		STATE_MOTOR_CFG_PRE_SET,
		STATE_MOTOR_CFG_READ,
		STATE_MOTOR_CFG_WRITE
		);
END_TYPE
