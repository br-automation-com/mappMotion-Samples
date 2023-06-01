
ACTION AxisCfgAction: 
	CASE AxisCfgState OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_AXIS_CFG_WAIT:
			IF AxisCfg.CmdGetAxis OR AxisCfg.CmdSetAxis THEN
				// Reset function blocks
				AxisCfgProcessConfig.Execute := FALSE;
				AxisCfg.ErrId := ERR_OK;

				AxisCfgState := STATE_AXIS_CFG_PRE_SET;
			END_IF

		// --------------------------------------------------------------------------
		// Generate address and channel string
		STATE_AXIS_CFG_PRE_SET:
			AxisCfgGetHardwareInfo.Execute := TRUE;
			AxisCfgGetHardwareInfo.Axis := AxisCfg.MpLink;
			
			// Finish when done
			IF AxisCfgGetHardwareInfo.Done OR AxisCfgGetHardwareInfo.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := AxisCfgGetHardwareInfo.ErrorID;		
				AxisCfgGetHardwareInfo.Execute := FALSE;
			
				// Abort when error
				IF AxisCfgGetHardwareInfo.Error THEN
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
					
					AxisCfgState := STATE_AXIS_CFG_WAIT;
				ELSE
					// Transfer name, read base type first
					AxisCfgName := AxisCfgGetHardwareInfo.HardwareInfo.Axis.AxisName;
					AxisCfgProcessConfig.DataType := mcCFG_AX_BASE_TYP; 

					// Proceed with command read
					IF AxisCfg.CmdGetAxis THEN
						AxisCfgProcessConfig.DataAddress := ADR(AxisCfg.StaAxis.BaseType);
						AxisCfgState := STATE_AXIS_CFG_READ;
					// Proceed with command write
					ELSE
						AxisCfgProcessConfig.DataAddress := ADR(AxisCfg.ParAxis.BaseType);
						AxisCfgState := STATE_AXIS_CFG_WRITE;						
					END_IF
				END_IF
			END_IF
			
			
		// --------------------------------------------------------------------------
		// Read Axis data
		STATE_AXIS_CFG_READ:
			// Read Axis configuration
			AxisCfgProcessConfig.Execute := TRUE; 
			AxisCfgProcessConfig.Name := AxisCfgName;
			AxisCfgProcessConfig.Mode := mcPCM_LOAD;

			// Finish when done
			IF AxisCfgProcessConfig.Done OR AxisCfgProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := AxisCfgProcessConfig.ErrorID;		
				AxisCfgProcessConfig.Execute := FALSE;
			
				// Abort when error
				IF AxisCfgProcessConfig.Error THEN				
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
					
					AxisCfgState := STATE_AXIS_CFG_WAIT;
				// Proceed with next step
				ELSE
					// Read movement limits in second run
					IF AxisCfgProcessConfig.DataType = mcCFG_AX_BASE_TYP THEN
						AxisCfgProcessConfig.DataType := mcCFG_AX_MOVE_LIM;
						AxisCfgProcessConfig.DataAddress := ADR(AxisCfg.StaAxis.MovementLimits);
					// Finish command read
					ELSE
						AxisCfg.CmdGetAxis := FALSE;					
						AxisCfgState := STATE_AXIS_CFG_WAIT;
					END_IF
				END_IF
			END_IF

			// --------------------------------------------------------------------------
			// Write axis data
		STATE_AXIS_CFG_WRITE:
			// Read axis configuration
			AxisCfgProcessConfig.Execute := TRUE; 
			AxisCfgProcessConfig.Name := AxisCfgName;
			AxisCfgProcessConfig.Mode := mcPCM_SAVE;

			// Finish when done
			IF AxisCfgProcessConfig.Done OR AxisCfgProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := AxisCfgProcessConfig.ErrorID;		
				AxisCfgProcessConfig.Execute := FALSE;
				
				// Write movement limits in second run
				IF AxisCfgProcessConfig.DataType = mcCFG_AX_BASE_TYP  AND NOT AxisCfgProcessConfig.Error THEN
					AxisCfgProcessConfig.DataType := mcCFG_AX_MOVE_LIM; 
					AxisCfgProcessConfig.DataAddress := ADR(AxisCfg.ParAxis.MovementLimits);
				// Finish when done or on error
				ELSE			
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
						
					AxisCfgState := STATE_AXIS_CFG_WAIT;
				END_IF
			END_IF
	END_CASE

	// Cyclic function calls
	AxisCfgProcessConfig();
	AxisCfgGetHardwareInfo();

END_ACTION
