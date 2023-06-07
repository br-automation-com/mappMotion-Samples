
ACTION MotorCfgAction: 
	// --------------------------------------------------------------------------
	// Reboot PLC
	IF AxisMotorCfg.CmdReboot THEN
		SYSreset(TRUE, SYSLIB_WARMSTART);
	END_IF
	
	// --------------------------------------------------------------------------
	// State machine for motor configuration
	CASE AxisMotorCfgInternal.State OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_MOTOR_CFG_WAIT:
			IF AxisMotorCfg.CmdGetMotor OR AxisMotorCfg.CmdSetMotor THEN
				// Reset function blocks and errors
				AxisMotorCfgInternal.ProcessConfig.Execute := FALSE;
				AxisMotorCfg.ErrId := ERR_OK;	

				AxisMotorCfgInternal.State := STATE_MOTOR_CFG_PRE_SET;
			END_IF

			// --------------------------------------------------------------------------
			// Generate address and channel string
		STATE_MOTOR_CFG_PRE_SET:
			AxisMotorCfgInternal.GetHardwareInfo.Execute := TRUE;
			AxisMotorCfgInternal.GetHardwareInfo.Axis := AxisMotorCfg.MpLink;
			
			// Finish when done
			IF AxisMotorCfgInternal.GetHardwareInfo.Done OR AxisMotorCfgInternal.GetHardwareInfo.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := AxisMotorCfgInternal.GetHardwareInfo.ErrorID;		
				AxisMotorCfgInternal.GetHardwareInfo.Execute := FALSE;
			
				// Abort when error or command was read
				IF AxisMotorCfgInternal.GetHardwareInfo.Error THEN
					AxisMotorCfg.CmdSetMotor := FALSE;				
					AxisMotorCfg.CmdGetMotor := FALSE;
					
					AxisMotorCfgInternal.State := STATE_MOTOR_CFG_WAIT;
				ELSE
					// Make sure location is not empty
					IF AxisMotorCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation <> '' THEN
						// Extract location string
						AxisMotorCfgInternal.n := FIND(AxisMotorCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, '/');
						IF AxisMotorCfgInternal.n > 0 THEN
							AxisMotorCfgInternal.Address := LEFT(AxisMotorCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, AxisMotorCfgInternal.n - 1);
							AxisMotorCfgInternal.Channel := RIGHT(AxisMotorCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, 8);
							IF AxisMotorCfgInternal.Channel = 'Channel1' THEN
								AxisMotorCfgInternal.Address := CONCAT(AxisMotorCfgInternal.Address, '.M1/M1');
							ELSIF AxisMotorCfgInternal.Channel = 'Channel2' THEN
								AxisMotorCfgInternal.Address := CONCAT(AxisMotorCfgInternal.Address, '.M2/M1');
							ELSE
								AxisMotorCfgInternal.Address := CONCAT(AxisMotorCfgInternal.Address, '.M3/M1');
							END_IF
							
							// Procced with command read
							IF AxisMotorCfg.CmdGetMotor THEN
								AxisMotorCfgInternal.State := STATE_MOTOR_CFG_READ;
								// Procced with command write
							ELSE
								AxisMotorCfgInternal.State := STATE_MOTOR_CFG_WRITE;
							END_IF
							// Cannot extract location string
						ELSE
							AxisMotorCfg.ErrId := ERR_AXISMOTORCFG_LOC_INVALID;			
							AxisMotorCfg.CmdSetMotor := FALSE;					
							AxisMotorCfg.CmdGetMotor := FALSE;					
							AxisMotorCfgInternal.State := STATE_MOTOR_CFG_WAIT;
						END_IF
						// Location is not empty
					ELSE
						AxisMotorCfg.ErrId := ERR_AXISMOTORCFG_LOC_EMPTY;			
						AxisMotorCfg.CmdSetMotor := FALSE;					
						AxisMotorCfg.CmdGetMotor := FALSE;					
						AxisMotorCfgInternal.State := STATE_MOTOR_CFG_WAIT;
					END_IF
				END_IF
			END_IF
			
			
			// --------------------------------------------------------------------------
			// Read motor data
		STATE_MOTOR_CFG_READ:
			// Read motor configuration
			AxisMotorCfgInternal.ProcessConfig.Execute := TRUE; 
			AxisMotorCfgInternal.ProcessConfig.Name := AxisMotorCfgInternal.Address;
			IF AxisMotorCfg.ParMotorType = AX_MOTOR_TYPE_SYNCHRONOUS THEN
				AxisMotorCfgInternal.ProcessConfig.DataAddress := ADR(AxisMotorCfg.StaMotorSynchronous);
				AxisMotorCfgInternal.ProcessConfig.DataType := mcCFG_MOT_SYN; 
			ELSE
				AxisMotorCfgInternal.ProcessConfig.DataAddress := ADR(AxisMotorCfg.StaMotorInduction);
				AxisMotorCfgInternal.ProcessConfig.DataType := mcCFG_MOT_INDUCT; 
			END_IF
			AxisMotorCfgInternal.ProcessConfig.Mode := mcPCM_LOAD;

			// Finish when done
			IF AxisMotorCfgInternal.ProcessConfig.Done OR AxisMotorCfgInternal.ProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := AxisMotorCfgInternal.ProcessConfig.ErrorID;		
				AxisMotorCfgInternal.ProcessConfig.Execute := FALSE;
			
				AxisMotorCfg.CmdSetMotor := FALSE;					
				AxisMotorCfg.CmdGetMotor := FALSE;
					
				AxisMotorCfgInternal.State := STATE_MOTOR_CFG_WAIT;
			END_IF

			// --------------------------------------------------------------------------
			// Write motor data
		STATE_MOTOR_CFG_WRITE:
			// Read motor configuration
			AxisMotorCfgInternal.ProcessConfig.Execute := TRUE; 
			AxisMotorCfgInternal.ProcessConfig.Name := AxisMotorCfgInternal.Address;
			IF AxisMotorCfg.ParMotorType = AX_MOTOR_TYPE_SYNCHRONOUS THEN
				AxisMotorCfgInternal.ProcessConfig.DataAddress := ADR(AxisMotorCfg.ParMotorSynchronous);
				AxisMotorCfgInternal.ProcessConfig.DataType := mcCFG_MOT_SYN; 
			ELSE
				AxisMotorCfgInternal.ProcessConfig.DataAddress := ADR(AxisMotorCfg.ParMotorInduction);
				AxisMotorCfgInternal.ProcessConfig.DataType := mcCFG_MOT_INDUCT; 
			END_IF
			AxisMotorCfgInternal.ProcessConfig.Mode := mcPCM_SAVE;

			// Finish when done
			IF AxisMotorCfgInternal.ProcessConfig.Done OR AxisMotorCfgInternal.ProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisMotorCfg.ErrId := AxisMotorCfgInternal.ProcessConfig.ErrorID;		
				AxisMotorCfgInternal.ProcessConfig.Execute := FALSE;
			
				AxisMotorCfg.CmdSetMotor := FALSE;					
				AxisMotorCfg.CmdGetMotor := FALSE;
					
				AxisMotorCfgInternal.State := STATE_MOTOR_CFG_WAIT;
			END_IF
	END_CASE

	// Cyclic function calls
	AxisMotorCfgInternal.ProcessConfig();
	AxisMotorCfgInternal.GetHardwareInfo();
END_ACTION
