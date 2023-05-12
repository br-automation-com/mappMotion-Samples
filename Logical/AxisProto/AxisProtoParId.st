
ACTION ParID:
	// Call parameter ID read and write
	IF AxisParId.CmdGetPar OR AxisParId.CmdSetPar THEN
		// Preset function block
		MC_BR_ProcessParID_AcpAx_1.Execute := 1;
		MC_BR_ProcessParID_AcpAx_1.Axis := ADR(AxisParId.ParAxis);
		MC_BR_ProcessParID_AcpAx_1.DataAddress := ADR(AxisParId.ParIds);
		MC_BR_ProcessParID_AcpAx_1.NumberOfParIDs := AxisParId.ParNum;
		IF AxisParId.CmdSetPar THEN
			MC_BR_ProcessParID_AcpAx_1.Mode := mcACPAX_PARID_SET;
		ELSE
			MC_BR_ProcessParID_AcpAx_1.Mode := mcACPAX_PARID_GET;
		END_IF		
		
		// Finish when done
		IF MC_BR_ProcessParID_AcpAx_1.Done OR MC_BR_ProcessParID_AcpAx_1.Error THEN
			// Transfer error id, reset funtion block, reset command
			AxisParId.ErrId := MC_BR_ProcessParID_AcpAx_1.ErrorID;
			
			MC_BR_ProcessParID_AcpAx_1.Execute := 0;
			
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
	MC_BR_ProcessParID_AcpAx_1();
END_ACTION
