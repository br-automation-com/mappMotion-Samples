
ACTION AxisDriveCfgAction:
	// --------------------------------------------------------------------------
	// Reboot PLC
	IF AxisDriveCfg.CmdReboot THEN
		SYSreset(TRUE, SYSLIB_WARMSTART);
	END_IF
	
	// --------------------------------------------------------------------------
	// State machine for axis configuration
	CASE AxisDriveCfgInternal.State OF
		// --------------------------------------------------------------------------
		// Wait for new command
		STATE_DRIVE_CFG_WAIT:
			// Command read configuration
			IF AxisDriveCfg.CmdGetDrive THEN
				// Reset function blocks and erros
				AxisDriveCfgInternal.ProcessConfig.Execute := FALSE;
				AxisDriveCfg.ErrId := ERR_OK;
				
				// Make correction for axis feature
				IF AxisDriveCfg.StaDrive.AxisFeatures.FeatureReference.DataAddress = 0 THEN
					AxisDriveCfg.StaDrive.AxisFeatures.FeatureReference.DataAddress := ADR(AxisDriveCfgInternal.myFeatures);
					AxisDriveCfg.StaDrive.AxisFeatures.FeatureReference.NumberOfArrayElements := SIZEOF(AxisDriveCfgInternal.myFeatures)/SIZEOF(AxisDriveCfgInternal.myFeatures[0]);
				END_IF

				AxisDriveCfgInternal.State := STATE_DRIVE_CFG_PRE_SET;
			END_IF

			// Command write configuration
			IF AxisDriveCfg.CmdSetDrive THEN			
				// Make axis feature has valid pointer
				IF AxisDriveCfg.StaDrive.AxisFeatures.FeatureReference.DataAddress = 0 AND AxisDriveCfg.StaDrive.AxisFeatures.FeatureReference.NumberOfElements > 0 THEN
					AxisDriveCfg.ErrId := ERR_AXISDRIVECFG_AX_FEATURE;
					AxisDriveCfg.CmdSetDrive := 0;
				ELSE
					// Reset function blocks and erros
					AxisDriveCfgInternal.ProcessConfig.Execute := FALSE;
					AxisDriveCfg.ErrId := ERR_OK;

					AxisDriveCfgInternal.State := STATE_DRIVE_CFG_PRE_SET;
				END_IF

			END_IF

		// --------------------------------------------------------------------------
		// Generate address and channel string
		STATE_DRIVE_CFG_PRE_SET:
			AxisDriveCfgInternal.GetHardwareInfo.Execute := TRUE;
			AxisDriveCfgInternal.GetHardwareInfo.Axis := AxisDriveCfg.MpLink;
			
			// Finish when done
			IF AxisDriveCfgInternal.GetHardwareInfo.Done OR AxisDriveCfgInternal.GetHardwareInfo.Error THEN
				// Transfer error id, reset function block
				AxisDriveCfg.ErrId := AxisDriveCfgInternal.GetHardwareInfo.ErrorID;		
				AxisDriveCfgInternal.GetHardwareInfo.Execute := FALSE;
			
				// Abort when error or command was read
				IF AxisDriveCfgInternal.GetHardwareInfo.Error THEN
					AxisDriveCfg.CmdSetDrive := FALSE;					
					AxisDriveCfg.CmdGetDrive := FALSE;
					
					AxisDriveCfgInternal.State := STATE_DRIVE_CFG_WAIT;
				ELSE
					// Make sure location is not empty
					IF AxisDriveCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation <> '' THEN
						// Extract location string
						AxisDriveCfgInternal.n := FIND(AxisDriveCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, '/');
						IF AxisDriveCfgInternal.n > 0 THEN
							AxisDriveCfgInternal.Address := LEFT(AxisDriveCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, AxisDriveCfgInternal.n - 1);
							AxisDriveCfgInternal.Channel := RIGHT(AxisDriveCfgInternal.GetHardwareInfo.HardwareInfo.Axis.ConfigElementLocation, 8);
							IF AxisDriveCfgInternal.Channel = 'Channel1' THEN
								AxisDriveCfgInternal.Address := CONCAT(AxisDriveCfgInternal.Address, '/DriveConfiguration/Channel1');
							ELSIF AxisDriveCfgInternal.Channel = 'Channel2' THEN
								AxisDriveCfgInternal.Address := CONCAT(AxisDriveCfgInternal.Address, '/DriveConfiguration/Channel2');
							ELSE
								AxisDriveCfgInternal.Address := CONCAT(AxisDriveCfgInternal.Address, '/DriveConfiguration/Channel3');
							END_IF
							
							// Proceed with command is get
							IF AxisDriveCfg.CmdGetDrive THEN
								AxisDriveCfgInternal.State := STATE_DRIVE_CFG_READ;
								// Proceed with command is set
							ELSE
								AxisDriveCfgInternal.State := STATE_DRIVE_CFG_WRITE;
							END_IF
							// Cannot extract location string
						ELSE
							AxisDriveCfg.ErrId := ERR_AXISDRIVECFG_LOC_INVALID;			
							AxisDriveCfg.CmdSetDrive := FALSE;					
							AxisDriveCfg.CmdGetDrive := FALSE;					
							AxisDriveCfgInternal.State := STATE_DRIVE_CFG_WAIT;
						END_IF
						// Location is not empty
					ELSE
						AxisDriveCfg.ErrId := ERR_AXISDRIVECFG_LOC_EMPTY;			
						AxisDriveCfg.CmdSetDrive := FALSE;					
						AxisDriveCfg.CmdGetDrive := FALSE;					
						AxisDriveCfgInternal.State := STATE_DRIVE_CFG_WAIT;
					END_IF
				END_IF
			END_IF
			
		// --------------------------------------------------------------------------
		// Read drive data
		STATE_DRIVE_CFG_READ:
			// Read Axis configuration
			AxisDriveCfgInternal.ProcessConfig.Execute := TRUE; 
			AxisDriveCfgInternal.ProcessConfig.Name := AxisDriveCfgInternal.Address;
			AxisDriveCfgInternal.ProcessConfig.DataType := mcCFG_ACP_AX; 
			AxisDriveCfgInternal.ProcessConfig.DataAddress := ADR(AxisDriveCfg.StaDrive);
			AxisDriveCfgInternal.ProcessConfig.Mode := mcPCM_LOAD;

			// Finish when done
			IF AxisDriveCfgInternal.ProcessConfig.Done OR AxisDriveCfgInternal.ProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisDriveCfg.ErrId := AxisDriveCfgInternal.ProcessConfig.ErrorID;		
				AxisDriveCfgInternal.ProcessConfig.Execute := FALSE;
				AxisDriveCfg.CmdGetDrive := FALSE;
					
				AxisDriveCfgInternal.State := STATE_DRIVE_CFG_WAIT;
			END_IF

		// --------------------------------------------------------------------------
		// Write drive data
		STATE_DRIVE_CFG_WRITE:
			// Read axis configuration
			AxisDriveCfgInternal.ProcessConfig.Execute := TRUE; 
			AxisDriveCfgInternal.ProcessConfig.Name := AxisDriveCfgInternal.Address;
			AxisDriveCfgInternal.ProcessConfig.DataType := mcCFG_ACP_AX; 
			AxisDriveCfgInternal.ProcessConfig.DataAddress := ADR(AxisDriveCfg.ParDrive);
			AxisDriveCfgInternal.ProcessConfig.Mode := mcPCM_SAVE;

			// Finish when done
			IF AxisDriveCfgInternal.ProcessConfig.Done OR AxisDriveCfgInternal.ProcessConfig.Error THEN
				// Transfer error id, reset function block
				AxisDriveCfg.ErrId := AxisDriveCfgInternal.ProcessConfig.ErrorID;		
				AxisDriveCfgInternal.ProcessConfig.Execute := FALSE;
				AxisDriveCfg.CmdSetDrive := FALSE;					
						
				AxisDriveCfgInternal.State := STATE_DRIVE_CFG_WAIT;
			END_IF
	END_CASE

	// --------------------------------------------------------------------------
	// Cyclic function calls
	AxisDriveCfgInternal.ProcessConfig();
	AxisDriveCfgInternal.GetHardwareInfo();

END_ACTION
