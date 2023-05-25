
ACTION AxisCfgAction: 
	CASE AxisCfgState OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_AXIS_CFG_WAIT:
			IF AxisCfg.CmdGetAxis OR AxisCfg.CmdSetAxis THEN
				// Reset function blocks
				MC_BR_ProcessConfig_1.Execute := FALSE;

				AxisCfgState := STATE_AXIS_CFG_PRE_SET;
			END_IF

		// --------------------------------------------------------------------------
		// Generate address and channel string
		STATE_AXIS_CFG_PRE_SET:
			MC_BR_GetHardwareInfo_1.Execute := TRUE;
			MC_BR_GetHardwareInfo_1.Axis := AxisCfg.MpLink;
			
			// Finish when done
			IF MC_BR_GetHardwareInfo_1.Done OR MC_BR_GetHardwareInfo_1.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := MC_BR_GetHardwareInfo_1.ErrorID;		
				MC_BR_GetHardwareInfo_1.Execute := FALSE;
			
				// Abort when error
				IF MC_BR_GetHardwareInfo_1.Error THEN
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
					
					AxisCfgState := STATE_AXIS_CFG_WAIT;
				ELSE
					// Transfer name, read base type first
					AxisCfgName := MC_BR_GetHardwareInfo_1.HardwareInfo.Axis.AxisName;
					MC_BR_ProcessConfig_1.DataType := mcCFG_AX_BASE_TYP; 
					MC_BR_ProcessConfig_1.DataAddress := ADR(AxisCfg.StaAxis.BaseType);

					AxisCfgState := STATE_AXIS_CFG_READ;
				END_IF
			END_IF
			
			
		// --------------------------------------------------------------------------
		// Read Axis data
		STATE_AXIS_CFG_READ:
			// Read Axis configuration
			MC_BR_ProcessConfig_1.Execute := TRUE; 
			MC_BR_ProcessConfig_1.Name := AxisCfgName;
			MC_BR_ProcessConfig_1.Mode := mcPCM_LOAD;

			// Finish when done
			IF MC_BR_ProcessConfig_1.Done OR MC_BR_ProcessConfig_1.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := MC_BR_ProcessConfig_1.ErrorID;		
				MC_BR_ProcessConfig_1.Execute := FALSE;
			
				// Abort when error
				IF MC_BR_ProcessConfig_1.Error THEN				
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
					
					AxisCfgState := STATE_AXIS_CFG_WAIT;
				// Proceed with next step
				ELSE
					// Read movement limits in second run
					IF MC_BR_ProcessConfig_1.DataType = mcCFG_AX_BASE_TYP THEN
						MC_BR_ProcessConfig_1.DataType := mcCFG_AX_MOVE_LIM;
						MC_BR_ProcessConfig_1.DataAddress := ADR(AxisCfg.StaAxis.MovementLimits);
					ELSE
						// Finish when command was read
						IF AxisCfg.CmdGetAxis THEN
							AxisCfg.CmdSetAxis := FALSE;					
							AxisCfg.CmdGetAxis := FALSE;
					
							AxisCfgState := STATE_AXIS_CFG_WAIT;
						// Proceed with write command
						ELSE
							// Write base parameter first
							MC_BR_ProcessConfig_1.DataType := mcCFG_AX_BASE_TYP; 
							MC_BR_ProcessConfig_1.DataAddress := ADR(AxisCfg.ParAxis.BaseType);

							AxisCfgState := STATE_AXIS_CFG_WRITE;
						END_IF
					END_IF
				END_IF
			END_IF

		// --------------------------------------------------------------------------
		// Write axis data
		STATE_AXIS_CFG_WRITE:
			// Read axis configuration
			MC_BR_ProcessConfig_1.Execute := TRUE; 
			MC_BR_ProcessConfig_1.Name := AxisCfgName;
			MC_BR_ProcessConfig_1.Mode := mcPCM_SAVE;

			// Finish when done
			IF MC_BR_ProcessConfig_1.Done OR MC_BR_ProcessConfig_1.Error THEN
				// Transfer error id, reset function block
				AxisCfg.ErrId := MC_BR_ProcessConfig_1.ErrorID;		
				MC_BR_ProcessConfig_1.Execute := FALSE;
				
				// Write movement limits in second run
				IF MC_BR_ProcessConfig_1.DataType = mcCFG_AX_BASE_TYP  AND NOT MC_BR_ProcessConfig_1.Error THEN
					MC_BR_ProcessConfig_1.DataType := mcCFG_AX_MOVE_LIM; 
					MC_BR_ProcessConfig_1.DataAddress := ADR(AxisCfg.ParAxis.MovementLimits);
				// Finish when done or on error
				ELSE			
					AxisCfg.CmdSetAxis := FALSE;					
					AxisCfg.CmdGetAxis := FALSE;
						
					AxisCfgState := STATE_AXIS_CFG_WAIT;
				END_IF
			END_IF
	END_CASE

	// Cyclic function calls
	MC_BR_ProcessConfig_1();
	MC_BR_GetHardwareInfo_1();

END_ACTION
