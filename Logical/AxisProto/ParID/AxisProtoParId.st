
ACTION ParIDAction:
	// --------------------------------------------------------------------------
	// Create get once queue
	IF AxisParIdInternal.DataOnceGetIdx = 0  THEN
		FOR AxisParIdInternal.n:=1 TO AxisParNum DO
			// Transfer get once data
			IF AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_GET_ONCE THEN
				AxisParIdInternal.DataOnceGetIdx := AxisParIdInternal.DataOnceGetIdx + 1;
				GetVarData;
				// Variable data is valid
				IF AxisParIdInternal.VariableStatus = 0 THEN
					AxisParIdInternal.DataOnceGet[AxisParIdInternal.DataOnceGetIdx].ParID := AxisParId.ParIds[AxisParIdInternal.n].ParID;
					AxisParIdInternal.DataOnceGet[AxisParIdInternal.DataOnceGetIdx].VariableAddress := AxisParIdInternal.McVariableAdr[AxisParIdInternal.n];
					AxisParIdInternal.DataOnceGet[AxisParIdInternal.DataOnceGetIdx].DataType := AxisParIdInternal.McVariableType[AxisParIdInternal.n];
				// Error reading variable data
				ELSE
					AxisParId.ErrId := AxisParIdInternal.VariableStatus;
					AxisParId.ParIds[AxisParIdInternal.n].Execute := mcACPAX_PARID_DONE;
				END_IF
			END_IF
		END_FOR;
	END_IF
	
	// --------------------------------------------------------------------------
	// Execute get once queue
	IF AxisParIdInternal.DataOnceGetIdx > 0 THEN
		// Preset function block
		AxisParIdInternal.ProcessParIDGet.Execute := 1;
		AxisParIdInternal.ProcessParIDGet.Axis := AxisParId.MpLink;
		AxisParIdInternal.ProcessParIDGet.DataAddress := ADR(AxisParIdInternal.DataOnceGet);
		AxisParIdInternal.ProcessParIDGet.NumberOfParIDs := AxisParIdInternal.DataOnceGetIdx;
		AxisParIdInternal.ProcessParIDGet.Mode := mcACPAX_PARID_GET;
			
		// Finish when done
		IF AxisParIdInternal.ProcessParIDGet.Done OR AxisParIdInternal.ProcessParIDGet.Error THEN
			// Transfer error id, reset funtion block, reset command
			IF AxisParId.ErrId = 0 THEN
				AxisParId.ErrId := AxisParIdInternal.ProcessParIDGet.ErrorID;
			END_IF

			FOR AxisParIdInternal.n:=1 TO AxisParNum DO
				FOR AxisParIdInternal.m:=1 TO AxisParIdInternal.DataOnceGetIdx DO
					IF AxisParIdInternal.DataOnceGet[AxisParIdInternal.m].ParID = AxisParId.ParIds[AxisParIdInternal.n].ParID AND AxisParIdInternal.DataOnceGet[AxisParIdInternal.m].VariableAddress = AxisParIdInternal.McVariableAdr[AxisParIdInternal.n] THEN
						AxisParId.ParIds[AxisParIdInternal.n].Execute := mcACPAX_PARID_DONE;
					END_IF
				END_FOR;
			END_FOR;
			brsmemset(ADR(AxisParIdInternal.DataOnceGet), 0, SIZEOF(AxisParIdInternal.DataOnceGet));
			AxisParIdInternal.DataOnceGetIdx := 0;			
			
			AxisParIdInternal.ProcessParIDGet.Execute := 0;
		END_IF
	END_IF
	
	// --------------------------------------------------------------------------
	// Create set once queue
	IF AxisParIdInternal.DataOnceSetIdx = 0  THEN
		FOR AxisParIdInternal.n:=1 TO AxisParNum DO
			// Transfer set once data
			IF AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_SET_ONCE THEN
				AxisParIdInternal.DataOnceSetIdx := AxisParIdInternal.DataOnceSetIdx + 1;
				GetVarData;
				// Variable data is valid
				IF AxisParIdInternal.VariableStatus = 0 THEN
					AxisParIdInternal.DataOnceSet[AxisParIdInternal.DataOnceSetIdx].ParID := AxisParId.ParIds[AxisParIdInternal.n].ParID;
					AxisParIdInternal.DataOnceSet[AxisParIdInternal.DataOnceSetIdx].VariableAddress := AxisParIdInternal.McVariableAdr[AxisParIdInternal.n];
					AxisParIdInternal.DataOnceSet[AxisParIdInternal.DataOnceSetIdx].DataType := AxisParIdInternal.McVariableType[AxisParIdInternal.n];
				// Error reading variable data
				ELSE
					AxisParId.ErrId := AxisParIdInternal.VariableStatus;
					AxisParId.ParIds[AxisParIdInternal.n].Execute := mcACPAX_PARID_DONE;
				END_IF

			END_IF
		END_FOR;
	END_IF
	
	// --------------------------------------------------------------------------
	// Execute set once queue
	IF AxisParIdInternal.DataOnceSetIdx > 0 THEN
		// Preset function block
		AxisParIdInternal.ProcessParIDSet.Execute := 1;
		AxisParIdInternal.ProcessParIDSet.Axis := AxisParId.MpLink;
		AxisParIdInternal.ProcessParIDSet.DataAddress := ADR(AxisParIdInternal.DataOnceSet);
		AxisParIdInternal.ProcessParIDSet.NumberOfParIDs := AxisParIdInternal.DataOnceSetIdx;
		AxisParIdInternal.ProcessParIDSet.Mode := mcACPAX_PARID_SET;
			
		// Finish when done
		IF AxisParIdInternal.ProcessParIDSet.Done OR AxisParIdInternal.ProcessParIDSet.Error THEN
			// Transfer error id, reset funtion block, reset command
			IF AxisParId.ErrId = 0 THEN
				AxisParId.ErrId := AxisParIdInternal.ProcessParIDSet.ErrorID;
			END_IF

			FOR AxisParIdInternal.n:=1 TO AxisParNum DO
				FOR AxisParIdInternal.m:=1 TO AxisParIdInternal.DataOnceSetIdx DO
					IF AxisParIdInternal.DataOnceSet[AxisParIdInternal.m].ParID = AxisParId.ParIds[AxisParIdInternal.n].ParID AND AxisParIdInternal.DataOnceSet[AxisParIdInternal.m].VariableAddress = AxisParIdInternal.McVariableAdr[AxisParIdInternal.n] THEN
						AxisParId.ParIds[AxisParIdInternal.n].Execute := mcACPAX_PARID_DONE;
					END_IF
				END_FOR;
			END_FOR;
			brsmemset(ADR(AxisParIdInternal.DataOnceSet), 0, SIZEOF(AxisParIdInternal.DataOnceSet));
			AxisParIdInternal.DataOnceSetIdx := 0;			
			
			AxisParIdInternal.ProcessParIDSet.Execute := 0;
		END_IF
	END_IF
	
	// --------------------------------------------------------------------------
	// Create get cylcic queue
	IF AxisParId.CmdUpdate THEN
		AxisParIdInternal.DataCyclicGetIdx := 0;
		brsmemset(ADR(AxisParIdInternal.DataCylicGet), 0, SIZEOF(AxisParIdInternal.DataCylicGet));
		AxisParId.ErrId := 0;
		FOR AxisParIdInternal.n:=1 TO AxisParNum DO
			// Transfer get cyclic data
			IF AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_GET_CYCLIC OR AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_GET_MULTI THEN
				AxisParIdInternal.DataCyclicGetIdx := AxisParIdInternal.DataCyclicGetIdx + 1;
				GetVarData;
				// Variable data is valid
				IF AxisParIdInternal.VariableStatus = 0 THEN
					AxisParIdInternal.DataCylicGet[AxisParIdInternal.DataCyclicGetIdx].ParID := AxisParId.ParIds[AxisParIdInternal.n].ParID;
					AxisParIdInternal.DataCylicGet[AxisParIdInternal.DataCyclicGetIdx].VariableAddress := AxisParIdInternal.McVariableAdr[AxisParIdInternal.n];
					AxisParIdInternal.DataCylicGet[AxisParIdInternal.DataCyclicGetIdx].DataType := AxisParIdInternal.McVariableType[AxisParIdInternal.n];
					IF AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_GET_CYCLIC THEN
						AxisParIdInternal.DataCylicGet[AxisParIdInternal.DataCyclicGetIdx].RefreshMode := mcACPAX_CYCLIC_EVERY_RECORD;
					ELSE
						AxisParIdInternal.DataCylicGet[AxisParIdInternal.DataCyclicGetIdx].RefreshMode := mcACPAX_CYCLIC_MULTIPLEXED;
					END_IF
				// Error reading variable data
				ELSE
					AxisParId.ErrId := AxisParIdInternal.VariableStatus;
					AxisParId.ParIds[AxisParIdInternal.n].Execute := mcACPAX_PARID_DONE;
				END_IF
			END_IF
		END_FOR;
	END_IF
	
	// --------------------------------------------------------------------------
	// Execute get cyclic queue
	IF AxisParIdInternal.DataCyclicGetIdx > 0 THEN
		// Preset function block
		AxisParIdInternal.CyclicProcessParIDGet.Enable := TRUE;
		AxisParIdInternal.CyclicProcessParIDGet.Axis := AxisParId.MpLink;
		AxisParIdInternal.CyclicProcessParIDGet.DataAddress := ADR(AxisParIdInternal.DataCylicGet);
		AxisParIdInternal.CyclicProcessParIDGet.NumberOfParIDs := AxisParIdInternal.DataCyclicGetIdx;
		AxisParIdInternal.CyclicProcessParIDGet.Mode := mcACPAX_CYCLIC_PARID_READ;
			
		// Log error
		IF AxisParIdInternal.CyclicProcessParIDGet.Error AND AxisParId.ErrId = 0 THEN
			AxisParId.ErrId := AxisParIdInternal.CyclicProcessParIDGet.ErrorID;
		END_IF
	ELSE
		AxisParIdInternal.CyclicProcessParIDGet.Enable := FALSE;
	END_IF

	// --------------------------------------------------------------------------
	// Create set cylcic queue
	IF AxisParId.CmdUpdate THEN
		AxisParIdInternal.DataCyclicSetIdx := 0;
		brsmemset(ADR(AxisParIdInternal.DataCylicSet), 0, SIZEOF(AxisParIdInternal.DataCylicSet));
		FOR AxisParIdInternal.n:=1 TO AxisParNum DO
			// Transfer set cyclic data
			IF AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_SET_CYCLIC OR AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_SET_MULTI THEN
				AxisParIdInternal.DataCyclicSetIdx := AxisParIdInternal.DataCyclicSetIdx + 1;
				GetVarData;
				// Variable data is valid
				IF AxisParIdInternal.VariableStatus = 0 THEN
					AxisParIdInternal.DataCylicSet[AxisParIdInternal.DataCyclicSetIdx].ParID := AxisParId.ParIds[AxisParIdInternal.n].ParID;
					AxisParIdInternal.DataCylicSet[AxisParIdInternal.DataCyclicSetIdx].VariableAddress := AxisParIdInternal.McVariableAdr[AxisParIdInternal.n];
					AxisParIdInternal.DataCylicSet[AxisParIdInternal.DataCyclicSetIdx].DataType := AxisParIdInternal.McVariableType[AxisParIdInternal.n];
					IF AxisParId.ParIds[AxisParIdInternal.n].Execute = mcACPAX_PARID_SET_CYCLIC THEN
						AxisParIdInternal.DataCylicSet[AxisParIdInternal.DataCyclicSetIdx].RefreshMode := mcACPAX_CYCLIC_EVERY_RECORD;
					ELSE
						AxisParIdInternal.DataCylicSet[AxisParIdInternal.DataCyclicSetIdx].RefreshMode := mcACPAX_CYCLIC_MULTIPLEXED;
					END_IF
				// Error reading variable data
				ELSE
					AxisParId.ErrId := AxisParIdInternal.VariableStatus;
					AxisParId.ParIds[AxisParIdInternal.n].Execute := mcACPAX_PARID_DONE;
				END_IF
	
			END_IF
		END_FOR;
	END_IF
	
	// --------------------------------------------------------------------------
	// Execute set cyclic queue
	IF AxisParIdInternal.DataCyclicSetIdx > 0 THEN
		// Preset function block
		AxisParIdInternal.CyclicProcessParIDSet.Enable := TRUE;
		AxisParIdInternal.CyclicProcessParIDSet.Axis := AxisParId.MpLink;
		AxisParIdInternal.CyclicProcessParIDSet.DataAddress := ADR(AxisParIdInternal.DataCylicSet);
		AxisParIdInternal.CyclicProcessParIDSet.NumberOfParIDs := AxisParIdInternal.DataCyclicSetIdx;
		AxisParIdInternal.CyclicProcessParIDSet.Mode := mcACPAX_CYCLIC_PARID_WRITE;
			
		// Log error
		IF AxisParIdInternal.CyclicProcessParIDSet.Error AND AxisParId.ErrId = 0 THEN
			AxisParId.ErrId := AxisParIdInternal.CyclicProcessParIDSet.ErrorID;
		END_IF
	ELSE
		AxisParIdInternal.CyclicProcessParIDSet.Enable := FALSE;
	END_IF	
	
	// Cyclic function calls
	AxisParIdInternal.ProcessParIDGet();
	AxisParIdInternal.ProcessParIDSet();
	AxisParIdInternal.CyclicProcessParIDGet();
	AxisParIdInternal.CyclicProcessParIDSet();
	
	AxisParId.CmdUpdate := FALSE;
END_ACTION

// --------------------------------------------------------------------------
// Get variable details
ACTION GetVarData:
	// Get variable address
	AxisParIdInternal.VariableStatus := PV_xgetadr(ADR(AxisParId.ParIds[AxisParIdInternal.n].Variable), ADR(AxisParIdInternal.VariableAdr), ADR(AxisParIdInternal.VariableLen));
	IF AxisParIdInternal.VariableStatus = 0 THEN
		// Get variable data type
		AxisParIdInternal.VariableStatus := PV_ninfo(ADR(AxisParId.ParIds[AxisParIdInternal.n].Variable), ADR(AxisParIdInternal.VariableType), ADR(AxisParIdInternal.VariableLen), ADR(AxisParIdInternal.VariableDimension));
		IF AxisParIdInternal.VariableStatus = 0 THEN
			// Transfer address and translate variable type to mc type
			AxisParIdInternal.McVariableAdr[AxisParIdInternal.n] := AxisParIdInternal.VariableAdr;
			// If variable if structure or array, use void
			IF AxisParIdInternal.VariableDimension > 1 THEN
				AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_VOID;
			// Assign type for standard types
			ELSE
				CASE AxisParIdInternal.VariableType OF
					SYSLIB_IEC_TYPE_BOOL:
			  			AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_BOOL;
					SYSLIB_IEC_TYPE_REAL:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_REAL;
					SYSLIB_IEC_TYPE_SINT:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_SINT;
					SYSLIB_IEC_TYPE_USINT:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_USINT;
					SYSLIB_IEC_TYPE_INT:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_INT;
					SYSLIB_IEC_TYPE_UINT:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_UINT;
					SYSLIB_IEC_TYPE_DINT:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_DINT;
					SYSLIB_IEC_TYPE_UDINT:
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_UDINT;
					ELSE
						AxisParIdInternal.McVariableType[AxisParIdInternal.n] := mcACPAX_PARTYPE_VOID;
				END_CASE;
			END_IF
		ELSE
			IF AxisParId.ErrId = 0 THEN
				AxisParId.ErrId := AxisParIdInternal.VariableStatus;
			END_IF
		END_IF
	ELSE
		IF AxisParId.ErrId = 0 THEN
			AxisParId.ErrId := AxisParIdInternal.VariableStatus;
		END_IF
	END_IF
END_ACTION


