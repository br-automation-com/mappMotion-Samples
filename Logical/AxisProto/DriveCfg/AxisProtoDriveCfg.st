
ACTION AxisDriveCfgAction:
	CASE AxisDriveCfgState OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_DRIVE_CFG_WAIT:
			IF AxisDriveCfg.CmdGetDrive OR AxisDriveCfg.CmdSetDrive THEN
				// Reset function blocks and erros
				AxisDriveCfgProcessConfig.Execute := FALSE;
				AxisDriveCfg.ErrId := ERR_OK;

				AxisDriveCfgState := STATE_DRIVE_CFG_PRE_SET;
			END_IF

			// --------------------------------------------------------------------------
			// Generate address and channel string
		STATE_DRIVE_CFG_PRE_SET:
			AxisDriveCfgGetHardwareInfo.Execute := TRUE;
			AxisDriveCfgGetHardwareInfo.Axis := AxisDriveCfg.MpLink;
			
			// Finish when done
			IF AxisDriveCfgGetHardwareInfo.Done OR AxisDriveCfgGetHardwareInfo.Error THEN
				// Transfer error id, reset function block
				AxisDriveCfg.ErrId := AxisDriveCfgGetHardwareInfo.ErrorID;		
				AxisDriveCfgGetHardwareInfo.Execute := FALSE;
			
				// Abort when error or command was read
				IF AxisDriveCfgGetHardwareInfo.Error THEN
					AxisDriveCfg.CmdSetDrive := FALSE;					
					AxisDriveCfg.CmdGetDrive := FALSE;
					
					AxisDriveCfgState := STATE_DRIVE_CFG_WAIT;
				ELSE
					// Make sure location is not empty
					IF AxisDriveCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation <> '' THEN
						// Extract location string
						n := FIND(AxisDriveCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, '/');
						IF n > 0 THEN
							AxisCommonCfgAddress := LEFT(AxisDriveCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, n - 1);
							AxisCommonCfgChannel := RIGHT(AxisDriveCfgGetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, 8);
							IF AxisCommonCfgChannel = 'Channel1' THEN
								AxisCommonCfgAddress := CONCAT(AxisCommonCfgAddress, '/DriveConfiguration/Channel1');
							ELSIF AxisCommonCfgChannel = 'Channel2' THEN
								AxisCommonCfgAddress := CONCAT(AxisCommonCfgAddress, '/DriveConfiguration/Channel2');
							ELSE
								AxisCommonCfgAddress := CONCAT(AxisCommonCfgAddress, '/DriveConfiguration/Channel3');
							END_IF
							
							// Proceed with command is get
							IF AxisDriveCfg.CmdGetDrive THEN
								AxisDriveCfgState := STATE_DRIVE_CFG_READ;
								// Proceed with command is set
							ELSE
								AxisDriveCfgState := STATE_DRIVE_CFG_WRITE;
							END_IF
							// Cannot extract location string
						ELSE
							AxisDriveCfg.ErrId := ERR_AXISDRIVECFG_LOC_INVALID;			
							AxisDriveCfg.CmdSetDrive := FALSE;					
							AxisDriveCfg.CmdGetDrive := FALSE;					
							AxisDriveCfgState := STATE_DRIVE_CFG_WAIT;
						END_IF
						// Location is not empty
					ELSE
						AxisDriveCfg.ErrId := ERR_AXISDRIVECFG_LOC_EMPTY;			
						AxisDriveCfg.CmdSetDrive := FALSE;					
						AxisDriveCfg.CmdGetDrive := FALSE;					
						AxisDriveCfgState := STATE_DRIVE_CFG_WAIT;
					END_IF
				END_IF
			END_IF	
			
			// --------------------------------------------------------------------------
			// Read drive data
		STATE_DRIVE_CFG_READ:
			// Read Axis configuration
			AxisDriveCfgProcessConfig.Execute := TRUE; 
			AxisDriveCfgProcessConfig.Name := AxisCommonCfgAddress;
			AxisDriveCfgProcessConfig.DataType := mcCFG_ACP_AX; 
			AxisDriveCfgProcessConfig.DataAddress := ADR(AxisDriveCfg.StaDrive);
			AxisDriveCfgProcessConfig.Mode := mcPCM_LOAD;

			// Finish when done
			IF AxisDriveCfgProcessConfig.Done OR AxisDriveCfgProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisDriveCfg.ErrId := AxisDriveCfgProcessConfig.ErrorID;		
				AxisDriveCfgProcessConfig.Execute := FALSE;
				AxisDriveCfg.CmdGetDrive := FALSE;
					
				AxisDriveCfgState := STATE_DRIVE_CFG_WAIT;
			END_IF

			// --------------------------------------------------------------------------
			// Write drive data
		STATE_DRIVE_CFG_WRITE:
			// Read axis configuration
			AxisDriveCfgProcessConfig.Execute := TRUE; 
			AxisDriveCfgProcessConfig.Name := AxisCommonCfgAddress;
			AxisDriveCfgProcessConfig.DataType := mcCFG_ACP_AX; 
			AxisDriveCfgProcessConfig.DataAddress := ADR(AxisDriveCfg.ParDrive);
			AxisDriveCfgProcessConfig.Mode := mcPCM_SAVE;

			// Finish when done
			IF AxisDriveCfgProcessConfig.Done OR AxisDriveCfgProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisDriveCfg.ErrId := AxisDriveCfgProcessConfig.ErrorID;		
				AxisDriveCfgProcessConfig.Execute := FALSE;
				AxisDriveCfg.CmdSetDrive := FALSE;					
						
				AxisDriveCfgState := STATE_DRIVE_CFG_WAIT;
			END_IF
	END_CASE

	// --------------------------------------------------------------------------
	// Cyclic function calls
	AxisDriveCfgProcessConfig();
	AxisDriveCfgGetHardwareInfo();

END_ACTION
