
ACTION AxisCfgAction:
	// --------------------------------------------------------------------------
	// Reboot PLC
	IF AxisCfg.CmdReboot THEN
		SYSreset(TRUE, SYSLIB_WARMSTART);
	END_IF
	
	// --------------------------------------------------------------------------
	// State machine for axis configuration
	CASE AxisCfgInternal.State OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_AXIS_CFG_WAIT:
			IF AxisCfg.CmdGetAxis OR AxisCfg.CmdSetAxis THEN
				// Reset function blocks
				AxisCfgInternal.ProcessConfig.Execute := FALSE;
				AxisCfg.ErrId := ERR_OK;

				AxisCfgInternal.State := STATE_AXIS_CFG_PRE_SET;
			END_IF

		// --------------------------------------------------------------------------
		// Generate address and channel string
		STATE_AXIS_CFG_PRE_SET:
			AxisCfgInternal.GetHardwareInfo.Execute := TRUE;
			AxisCfgInternal.GetHardwareInfo.Axis := AxisCfg.MpLink;
			
			// Finish when done
			IF AxisCfgInternal.GetHardwareInfo.Done OR AxisCfgInternal.GetHardwareInfo.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := AxisCfgInternal.GetHardwareInfo.ErrorID;		
				AxisCfgInternal.GetHardwareInfo.Execute := FALSE;
			
				// Abort when error
				IF AxisCfgInternal.GetHardwareInfo.Error THEN
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
					
					AxisCfgInternal.State := STATE_AXIS_CFG_WAIT;
				ELSE
					// Transfer name, read base type first
					AxisCfgInternal.Name := AxisCfgInternal.GetHardwareInfo.HardwareInfo.Axis.AxisName;
					AxisCfgInternal.ProcessConfig.DataType := mcCFG_AX_BASE_TYP; 

					// Proceed with command read
					IF AxisCfg.CmdGetAxis THEN
						AxisCfgInternal.ProcessConfig.DataAddress := ADR(AxisCfg.StaAxis.BaseType);
						AxisCfgInternal.State := STATE_AXIS_CFG_READ;
					// Proceed with command write
					ELSE
						AxisCfgInternal.ProcessConfig.DataAddress := ADR(AxisCfg.ParAxis.BaseType);
						AxisCfgInternal.State := STATE_AXIS_CFG_WRITE;						
					END_IF
				END_IF
			END_IF
			
			
		// --------------------------------------------------------------------------
		// Read Axis data
		STATE_AXIS_CFG_READ:
			// Read Axis configuration
			AxisCfgInternal.ProcessConfig.Execute := TRUE; 
			AxisCfgInternal.ProcessConfig.Name := AxisCfgInternal.Name;
			AxisCfgInternal.ProcessConfig.Mode := mcPCM_LOAD;

			// Finish when done
			IF AxisCfgInternal.ProcessConfig.Done OR AxisCfgInternal.ProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := AxisCfgInternal.ProcessConfig.ErrorID;		
				AxisCfgInternal.ProcessConfig.Execute := FALSE;
			
				// Abort when error
				IF AxisCfgInternal.ProcessConfig.Error THEN				
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
					
					AxisCfgInternal.State := STATE_AXIS_CFG_WAIT;
				// Proceed with next step
				ELSE
					// Read movement limits in second run
					IF AxisCfgInternal.ProcessConfig.DataType = mcCFG_AX_BASE_TYP THEN
						AxisCfgInternal.ProcessConfig.DataType := mcCFG_AX_MOVE_LIM;
						AxisCfgInternal.ProcessConfig.DataAddress := ADR(AxisCfg.StaAxis.MovementLimits);
					// Finish command read
					ELSE
						AxisCfg.CmdGetAxis := FALSE;					
						AxisCfgInternal.State := STATE_AXIS_CFG_WAIT;
					END_IF
				END_IF
			END_IF

			// --------------------------------------------------------------------------
			// Write axis data
		STATE_AXIS_CFG_WRITE:
			// Read axis configuration
			AxisCfgInternal.ProcessConfig.Execute := TRUE; 
			AxisCfgInternal.ProcessConfig.Name := AxisCfgInternal.Name;
			AxisCfgInternal.ProcessConfig.Mode := mcPCM_SAVE;

			// Finish when done
			IF AxisCfgInternal.ProcessConfig.Done OR AxisCfgInternal.ProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := AxisCfgInternal.ProcessConfig.ErrorID;		
				AxisCfgInternal.ProcessConfig.Execute := FALSE;
				
				// Write movement limits in second run
				IF AxisCfgInternal.ProcessConfig.DataType = mcCFG_AX_BASE_TYP  AND NOT AxisCfgInternal.ProcessConfig.Error THEN
					AxisCfgInternal.ProcessConfig.DataType := mcCFG_AX_MOVE_LIM; 
					AxisCfgInternal.ProcessConfig.DataAddress := ADR(AxisCfg.ParAxis.MovementLimits);
				// Finish when done or on error
				ELSE			
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
						
					AxisCfgInternal.State := STATE_AXIS_CFG_WAIT;
				END_IF
			END_IF
	END_CASE

	// Cyclic function calls
	AxisCfgInternal.ProcessConfig();
	AxisCfgInternal.GetHardwareInfo();

END_ACTION
