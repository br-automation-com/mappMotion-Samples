
ACTION BrakeAction:
	// --------------------------------------------------------------------------
	// Set brake parameters
	IF AxisBrake.CmdSetPar THEN
		// Preset function block
		MC_BR_BrakeSetPar_AcpAx_1.Execute := 1;
		MC_BR_BrakeSetPar_AcpAx_1.Axis := AxisBrake.MpLink;
		MC_BR_BrakeSetPar_AcpAx_1.Parameters := AxisBrake.ParBrake;
		
		// Finish when done
		IF MC_BR_BrakeSetPar_AcpAx_1.Done OR MC_BR_BrakeSetPar_AcpAx_1.Error THEN
			// Transfer error id, reset funtion block, reset command
			AxisBrake.ErrId := MC_BR_BrakeSetPar_AcpAx_1.ErrorID;		
			MC_BR_BrakeSetPar_AcpAx_1.Execute := 0;
			AxisBrake.CmdSetPar := FALSE;
		END_IF
	END_IF
	
	// --------------------------------------------------------------------------
	// Open or close brake
	IF AxisBrake.CmdOpen OR AxisBrake.CmdClose THEN
		CASE AxisBrakeState OF
			// --------------------------------------------------------------------------
			// Wait state
			STATE_BRAKE_WAIT:
				// Command open brake
				IF AxisBrake.CmdOpen THEN
					MC_BR_BrakeOperation_1.Command := mcBRAKE_OPEN;
					AxisBrakeState := STATE_BRAKE_OPEN_CLOSE;
				END_IF

				// Command close brake
				IF AxisBrake.CmdClose THEN
					MC_BR_BrakeOperation_1.Command := mcBRAKE_CLOSE;
					AxisBrakeState := STATE_BRAKE_OPEN_CLOSE;
				END_IF

			// --------------------------------------------------------------------------
			// Set brake state
			STATE_BRAKE_OPEN_CLOSE:
				// Preset function block
				MC_BR_BrakeOperation_1.Execute := TRUE;
				MC_BR_BrakeOperation_1.Axis := AxisBrake.MpLink;
		
				// Finish when done
				IF MC_BR_BrakeOperation_1.Done OR MC_BR_BrakeOperation_1.Error THEN
					// Transfer error id, reset function block
					AxisBrake.ErrId := MC_BR_BrakeOperation_1.ErrorID;		
					MC_BR_BrakeOperation_1.Execute := FALSE;
			
					// Abort when error
					IF MC_BR_BrakeOperation_1.Error THEN
						AxisBrake.CmdOpen := FALSE;
						AxisBrake.CmdClose := FALSE;
						
						AxisBrakeState := STATE_BRAKE_WAIT;
					ELSE
						AxisBrakeState := STATE_BRAKE_STATUS;
					END_IF
				END_IF
				
			// --------------------------------------------------------------------------
			// Get brake status
			STATE_BRAKE_STATUS:
				// Preset function block
				MC_BR_BrakeOperation_1.Execute := 1;
				MC_BR_BrakeOperation_1.Axis := AxisBrake.MpLink;
				MC_BR_BrakeOperation_1.Command := mcBRAKE_GET_STATUS;
				MC_BR_BrakeOperation_1();
		
				// Finish when done
				IF MC_BR_BrakeOperation_1.Done OR MC_BR_BrakeOperation_1.Error THEN
					// Transfer error id, status, reset funtion block, reset command
					AxisBrake.ErrId := MC_BR_BrakeOperation_1.ErrorID;
					AxisBrake.StaBrake := MC_BR_BrakeOperation_1.BrakeStatus;
			
					MC_BR_BrakeOperation_1.Execute := 0;
			
					AxisBrake.CmdOpen := FALSE;
					AxisBrake.CmdClose := FALSE;
					
					AxisBrakeState := STATE_BRAKE_WAIT;
				END_IF
		END_CASE;
	END_IF
	
	// Cyclic function calls
	MC_BR_BrakeSetPar_AcpAx_1();
	MC_BR_BrakeOperation_1();
	
END_ACTION
