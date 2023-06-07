
TYPE
	AxisParIdModeType : 
		(
		mcACPAX_PARID_DONE,
		mcACPAX_PARID_GET_ONCE,
		mcACPAX_PARID_SET_ONCE,
		mcACPAX_PARID_GET_CYCLIC,
		mcACPAX_PARID_SET_CYCLIC,
		mcACPAX_PARID_GET_MULTI,
		mcACPAX_PARID_SET_MULTI
		);
	AxisParIdInternalType : 	STRUCT 
		ProcessParIDGet : MC_BR_ProcessParID_AcpAx;
		ProcessParIDSet : MC_BR_ProcessParID_AcpAx;
		CyclicProcessParIDGet : MC_BR_CyclicProcessParID_AcpAx;
		CyclicProcessParIDSet : MC_BR_CyclicProcessParID_AcpAx;
		DataOnceGet : ARRAY[1..AxisParNum]OF McAcpAxProcessParIDType;
		DataOnceSet : ARRAY[1..AxisParNum]OF McAcpAxProcessParIDType;
		DataCylicGet : ARRAY[1..AxisParNum]OF McAcpAxCycParIDType;
		DataCylicSet : ARRAY[1..AxisParNum]OF McAcpAxCycParIDType;
		DataOnceGetIdx : USINT;
		DataOnceSetIdx : USINT;
		DataCyclicGetIdx : USINT;
		DataCyclicSetIdx : USINT;
		VariableStatus : UINT;
		VariableType : UDINT;
		VariableAdr : UDINT;
		VariableLen : UDINT;
		VariableDimension : UDINT;
		McVariableType : ARRAY[1..AxisParNum]OF UDINT;
		McVariableAdr : ARRAY[1..AxisParNum]OF UDINT;
		n : UINT;
		m : UINT;
	END_STRUCT;
	AxisParIdDataType : 	STRUCT 
		Execute : AxisParIdModeType;
		ParID : UINT;
		Variable : STRING[250];
	END_STRUCT;
	AxisParIdType : 	STRUCT 
		CmdResetError : BOOL;
		MpLink : REFERENCE TO McAxisType;
		ParIds : ARRAY[1..AxisParNum]OF AxisParIdDataType;
		ErrId : DINT;
	END_STRUCT;
END_TYPE
