
ACTION ParIDAction:
	// Call parameter ID read and write
	IF AxisParId.CmdGetPar OR AxisParId.CmdSetPar THEN
		// --------------------------------------------------------------------------
		// Connect ParID for cyclic access
		IF AxisParId.ParCyclic THEN
			// Preset function block
			AxisParIdCyclicProcessParID.Execute := 1;
			AxisParIdCyclicProcessParID.Axis := AxisParId.MpLink;
			AxisParIdCyclicProcessParID.DataAddress := ADR(AxisParId.ParIds);
			AxisParIdCyclicProcessParID.NumberOfParIDs := AxisParId.ParNum;
			IF AxisParId.CmdSetPar THEN
				AxisParIdCyclicProcessParID.Mode := mcACPAX_CYCLIC_PARID_READ;
			ELSE
				AxisParIdCyclicProcessParID.Mode := mcACPAX_CYCLIC_PARID_WRITE;
			END_IF		
			
			// Finish when done
			IF AxisParIdCyclicProcessParID.Done OR AxisParIdCyclicProcessParID.Error THEN
				// Transfer error id, reset funtion block, reset command
				AxisParId.ErrId := AxisParIdCyclicProcessParID.ErrorID;
				
				AxisParIdCyclicProcessParID.Execute := 0;
				
				AxisParId.CmdGetPar := FALSE;
				AxisParId.CmdSetPar := FALSE;
			END_IF
			
		// --------------------------------------------------------------------------
		// Connect ParID for one time access
		ELSE
			// Convert data from cyclic to one time access
			FOR n:=1 TO AxisParNum DO
	  			AxisParIdData[n].ParID := AxisParId.ParIds[n].ParID;
				AxisParIdData[n].VariableAddress := AxisParId.ParIds[n].VariableAddress;
				AxisParIdData[n].DataType := AxisParId.ParIds[n].DataType;
			END_FOR;
			
			// Preset function block
			AxisParIdProcessParID.Execute := 1;
			AxisParIdProcessParID.Axis := AxisParId.MpLink;
			AxisParIdProcessParID.DataAddress := ADR(AxisParIdData);
			AxisParIdProcessParID.NumberOfParIDs := AxisParId.ParNum;
			IF AxisParId.CmdSetPar THEN
				AxisParIdProcessParID.Mode := mcACPAX_PARID_SET;
			ELSE
				AxisParIdProcessParID.Mode := mcACPAX_PARID_GET;
			END_IF		
			
			// Finish when done
			IF AxisParIdProcessParID.Done OR AxisParIdProcessParID.Error THEN
				// Transfer error id, reset funtion block, reset command
				AxisParId.ErrId := AxisParIdProcessParID.ErrorID;
				
				AxisParIdProcessParID.Execute := 0;
				
				AxisParId.CmdGetPar := FALSE;
				AxisParId.CmdSetPar := FALSE;
			END_IF
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
	AxisParIdProcessParID();
	AxisParIdCyclicProcessParID();
END_ACTION
