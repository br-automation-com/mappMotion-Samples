
TYPE
	AxisParIdType : 	STRUCT 
		CmdSetPar : BOOL;
		CmdGetPar : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParIds : ARRAY[1..AxisParNum]OF McAcpAxCycParIDType;
		ParNum : UDINT;
		ParCyclic : BOOL;
		ErrId : DINT;
	END_STRUCT;
END_TYPE
