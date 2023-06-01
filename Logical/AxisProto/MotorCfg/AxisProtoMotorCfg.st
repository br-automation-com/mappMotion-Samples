
ACTION MotorCfgAction: 
	CASE AxisMotorCfgState OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_MOTOR_CFG_WAIT:
			IF AxisMotorCfg.CmdGetMotor OR AxisMotorCfg.CmdSetMotor THEN
				// Reset function blocks and errors
				AxisMotorCfgProcessConfig.Execute := FALSE;
				AxisMotorCfg.ErrId := ERR_OK;	

				AxisMotorCfgState := STATE_MOTOR_CFG_PRE_SET;
			END_IF

			// --------------------------------------------------------------------------
			// Generate address and channel string
		STATE_MOTOR_CFG_PRE_SET:
			AxisMotorCfgGetHardwareInfo.Execute := TRUE;
			AxisMotorCfgGetHardwareInfo.Axis := AxisMotorCfg.MpLink;
			
			// Finish when done
			IF AxisMotorCfgGetHardwareInfo.Done OR AxisMotorCfgGetHardwareInfo.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := AxisMotorCfgGetHardwareInfo.ErrorID;		
				AxisMotorCfgGetHardwareInfo.Execute := FALSE;
			
				// Abort when error or command was read
				IF AxisMotorCfgGetHardwareInfo.Error THEN
					AxisMotorCfg.CmdSetMotor := FALSE;					
					AxisMotorCfg.CmdGetMotor := FALSE;
					
					AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
				ELSE
					// Make sure location is not empty
					IF AxisMotorCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation <> '' THEN
						// Extract location string
						n := FIND(AxisMotorCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, '/');
						IF n > 0 THEN
							AxisMotorCfgAddress := LEFT(AxisMotorCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, n - 1);
							AxisMotorCfgChannel := RIGHT(AxisMotorCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, 8);
							IF AxisMotorCfgChannel = 'Channel1' THEN
								AxisMotorCfgAddress := CONCAT(AxisMotorCfgAddress, '.M1/M1');
							ELSIF AxisMotorCfgChannel = 'Channel2' THEN
								AxisMotorCfgAddress := CONCAT(AxisMotorCfgAddress, '.M2/M1');
							ELSE
								AxisMotorCfgAddress := CONCAT(AxisMotorCfgAddress, '.M3/M1');
							END_IF
							
							// Procced with command read
							IF AxisMotorCfg.CmdGetMotor THEN
								AxisMotorCfgState := STATE_MOTOR_CFG_READ;
								// Procced with command write
							ELSE
								AxisMotorCfgState := STATE_MOTOR_CFG_WRITE;
							END_IF
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
			AxisMotorCfgProcessConfig.Execute := TRUE; 
			AxisMotorCfgProcessConfig.Name := AxisMotorCfgAddress;
			IF AxisMotorCfg.ParMotorType = AX_MOTOR_TYPE_SYNCHRONOUS THEN
				AxisMotorCfgProcessConfig.DataAddress := ADR(AxisMotorCfg.StaMotorSynchronous);
				AxisMotorCfgProcessConfig.DataType := mcCFG_MOT_SYN; 
			ELSE
				AxisMotorCfgProcessConfig.DataAddress := ADR(AxisMotorCfg.StaMotorInduction);
				AxisMotorCfgProcessConfig.DataType := mcCFG_MOT_INDUCT; 
			END_IF
			AxisMotorCfgProcessConfig.Mode := mcPCM_LOAD;

			// Finish when done
			IF AxisMotorCfgProcessConfig.Done OR AxisMotorCfgProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := AxisMotorCfgProcessConfig.ErrorID;		
				AxisMotorCfgProcessConfig.Execute := FALSE;
			
				AxisMotorCfg.CmdSetMotor := FALSE;					
				AxisMotorCfg.CmdGetMotor := FALSE;
					
				AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
			END_IF

			// --------------------------------------------------------------------------
			// Write motor data
		STATE_MOTOR_CFG_WRITE:
			// Read motor configuration
			AxisMotorCfgProcessConfig.Execute := TRUE; 
			AxisMotorCfgProcessConfig.Name := AxisMotorCfgAddress;
			IF AxisMotorCfg.ParMotorType = AX_MOTOR_TYPE_SYNCHRONOUS THEN
				AxisMotorCfgProcessConfig.DataAddress := ADR(AxisMotorCfg.ParMotorSynchronous);
				AxisMotorCfgProcessConfig.DataType := mcCFG_MOT_SYN; 
			ELSE
				AxisMotorCfgProcessConfig.DataAddress := ADR(AxisMotorCfg.ParMotorInduction);
				AxisMotorCfgProcessConfig.DataType := mcCFG_MOT_INDUCT; 
			END_IF
			AxisMotorCfgProcessConfig.Mode := mcPCM_SAVE;

			// Finish when done
			IF AxisMotorCfgProcessConfig.Done OR AxisMotorCfgProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := AxisMotorCfgProcessConfig.ErrorID;		
				AxisMotorCfgProcessConfig.Execute := FALSE;
			
				AxisMotorCfg.CmdSetMotor := FALSE;					
				AxisMotorCfg.CmdGetMotor := FALSE;
					
				AxisMotorCfgState := STATE_MOTOR_CFG_WAIT;
			END_IF
	END_CASE

	// Cyclic function calls
	AxisMotorCfgProcessConfig();
	AxisMotorCfgGetHardwareInfo();
END_ACTION
