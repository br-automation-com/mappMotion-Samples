
ACTION MotorCfg: 
	CASE AxisMotorCfgState OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_MOTOR_CFG_WAIT:
			IF AxisMotorCfg.CmdGetMotor OR AxisMotorCfg.CmdSetMotor THEN
				// Reset function blocks
				MC_BR_ProcessConfig_1.Execute := FALSE;

				AxisMotorCfgState := STATE_MOTOR_CFG_PRE_SET;
			END_IF

		// --------------------------------------------------------------------------
		// Generate address and channel string
		STATE_MOTOR_CFG_PRE_SET:
			MC_BR_GetHardwareInfo_1.Execute := TRUE;
			MC_BR_GetHardwareInfo_1.Axis := AxisMotorCfg.MpLink;
			
			// Finish when done
			IF MC_BR_GetHardwareInfo_1.Done OR MC_BR_GetHardwareInfo_1.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := MC_BR_GetHardwareInfo_1.ErrorID;		
				MC_BR_GetHardwareInfo_1.Execute := FALSE;
			
				// Abort when error or command was read
				IF MC_BR_GetHardwareInfo_1.Error THEN
					AxisMotorCfg.CmdSetMotor := FALSE;					
					AxisMotorCfg.CmdGetMotor := FALSE;
					
					AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
				ELSE
					// Make sure location is not empty
					IF MC_BR_GetHardwareInfo_1.HardwareInfo.Axis.ConfigElementLocation <> '' THEN
						// Extract location string
						n := FIND(MC_BR_GetHardwareInfo_1.HardwareInfo.Axis.ConfigElementLocation, '/');
						IF n > 0 THEN
							AxisMotorCfgAddress := LEFT(MC_BR_GetHardwareInfo_1.HardwareInfo.Axis.ConfigElementLocation, n - 1);
							AxisMotorCfgChannel := RIGHT(MC_BR_GetHardwareInfo_1.HardwareInfo.Axis.ConfigElementLocation, 8);
							IF AxisMotorCfgChannel = 'Channel1' THEN
								AxisMotorCfgAddress := CONCAT(AxisMotorCfgAddress, '.M1/M1');
							ELSIF AxisMotorCfgChannel = 'Channel2' THEN
								AxisMotorCfgAddress := CONCAT(AxisMotorCfgAddress, '.M2/M1');
							ELSE
								AxisMotorCfgAddress := CONCAT(AxisMotorCfgAddress, '.M3/M1');
							END_IF
							
							AxisMotorCfgState := STATE_MOTOR_CFG_READ;
						// Cannot extract location string
						ELSE
							AxisMotorCfg.ErrId := ERR_AXISMOTORCFG_LOC_INVALID;			
							AxisMotorCfg.CmdSetMotor := FALSE;					
							AxisMotorCfg.CmdGetMotor := FALSE;					
							AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
						END_IF
						// Location is not empty
					ELSE
						AxisMotorCfg.ErrId := ERR_AXISMOTORCFG_LOC_EMPTY;			
						AxisMotorCfg.CmdSetMotor := FALSE;					
						AxisMotorCfg.CmdGetMotor := FALSE;					
						AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
					END_IF
				END_IF
			END_IF
			
			
		// --------------------------------------------------------------------------
		// Read motor data
		STATE_MOTOR_CFG_READ:
			// Read motor configuration
			MC_BR_ProcessConfig_1.Execute := TRUE; 
			MC_BR_ProcessConfig_1.Name := AxisMotorCfgAddress;
			IF AxisMotorCfg.ParMotorType = AX_MOTOR_TYPE_SYNCHRONOUS THEN
				MC_BR_ProcessConfig_1.DataAddress := ADR(AxisMotorCfg.StaMotorSynchronous);
				MC_BR_ProcessConfig_1.DataType := mcCFG_MOT_SYN; 
			ELSE
				MC_BR_ProcessConfig_1.DataAddress := ADR(AxisMotorCfg.StaMotorInduction);
				MC_BR_ProcessConfig_1.DataType := mcCFG_MOT_INDUCT; 
			END_IF
			MC_BR_ProcessConfig_1.Mode := mcPCM_LOAD;

			// Finish when done
			IF MC_BR_ProcessConfig_1.Done OR MC_BR_ProcessConfig_1.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := MC_BR_ProcessConfig_1.ErrorID;		
				MC_BR_ProcessConfig_1.Execute := FALSE;
			
				// Abort when error or command was read
				IF MC_BR_ProcessConfig_1.Error OR AxisMotorCfg.CmdGetMotor THEN
					AxisMotorCfg.CmdSetMotor := FALSE;					
					AxisMotorCfg.CmdGetMotor := FALSE;
					
					AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
				ELSE
					AxisMotorCfgState := STATE_MOTOR_CFG_WRITE;
				END_IF
			END_IF

		// --------------------------------------------------------------------------
		// Write motor data
		STATE_MOTOR_CFG_WRITE:
			// Read motor configuration
			MC_BR_ProcessConfig_1.Execute := TRUE; 
			MC_BR_ProcessConfig_1.Name := AxisMotorCfgAddress;
			IF AxisMotorCfg.ParMotorType = AX_MOTOR_TYPE_SYNCHRONOUS THEN
				MC_BR_ProcessConfig_1.DataAddress := ADR(AxisMotorCfg.ParMotorSynchronous);
				MC_BR_ProcessConfig_1.DataType := mcCFG_MOT_SYN; 
			ELSE
				MC_BR_ProcessConfig_1.DataAddress := ADR(AxisMotorCfg.ParMotorInduction);
				MC_BR_ProcessConfig_1.DataType := mcCFG_MOT_INDUCT; 
			END_IF
			MC_BR_ProcessConfig_1.Mode := mcPCM_SAVE;

			// Finish when done
			IF MC_BR_ProcessConfig_1.Done OR MC_BR_ProcessConfig_1.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := MC_BR_ProcessConfig_1.ErrorID;		
				MC_BR_ProcessConfig_1.Execute := FALSE;
			
				AxisMotorCfg.CmdSetMotor := FALSE;					
				AxisMotorCfg.CmdGetMotor := FALSE;
					
				AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
			END_IF
	END_CASE

	// Cyclic function calls
	MC_BR_ProcessConfig_1();
	MC_BR_GetHardwareInfo_1();

END_ACTION
