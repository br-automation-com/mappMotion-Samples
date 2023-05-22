
TYPE
	AxisParIdType : 	STRUCT 
		CmdSetPar : BOOL;
		CmdGetPar : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParIds : ARRAY[1..AxisParNum]OF McAcpAxProcessParIDType;
		ParNum : UDINT;
		ErrId : DINT;
	END_STRUCT;
END_TYPE
