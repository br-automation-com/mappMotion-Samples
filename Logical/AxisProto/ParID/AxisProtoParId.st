
ACTION ParIDAction:
	// Call parameter ID read and write
	IF AxisParId.CmdGetPar OR AxisParId.CmdSetPar THEN
		// Preset function block
		AxisParIdProcessParID_AcpAx.Execute := 1;
		AxisParIdProcessParID_AcpAx.Axis := AxisParId.MpLink;
		AxisParIdProcessParID_AcpAx.DataAddress := ADR(AxisParId.ParIds);
		AxisParIdProcessParID_AcpAx.NumberOfParIDs := AxisParId.ParNum;
		IF AxisParId.CmdSetPar THEN
			AxisParIdProcessParID_AcpAx.Mode := mcACPAX_PARID_SET;
		ELSE
			AxisParIdProcessParID_AcpAx.Mode := mcACPAX_PARID_GET;
		END_IF		
		
		// Finish when done
		IF AxisParIdProcessParID_AcpAx.Done OR AxisParIdProcessParID_AcpAx.Error THEN
			// Transfer error id, reset funtion block, reset command
			AxisParId.ErrId := AxisParIdProcessParID_AcpAx.ErrorID;
			
			AxisParIdProcessParID_AcpAx.Execute := 0;
			
			AxisParId.CmdGetPar := FALSE;
			AxisParId.CmdSetPar := FALSE;
		END_IF
	END_IF
	
	// Avoid compiler warnings
	mcACPAX_BOOL;
	mcACPAX_SINT;
	mcACPAX_INT;
	mcACPAX_DINT;
	mcACPAX_USINT;
	mcACPAX_UINT;
	mcACPAX_UDINT;
	mcACPAX_REAL;
	
	// Cyclic function calls
	AxisParIdProcessParID_AcpAx();
END_ACTION
