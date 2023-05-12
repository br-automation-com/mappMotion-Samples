
ACTION Brake:
	// --------------------------------------------------------------------------
	// Set brake parameters
	IF AxisBrake.CmdSetPar THEN
		// Preset function block
		MC_BR_BrakeSetPar_AcpAx_1.Execute := 1;
		MC_BR_BrakeSetPar_AcpAx_1.Axis := ADR(AxisBrake.ParAxis);
		MC_BR_BrakeSetPar_AcpAx_1.Parameters := AxisBrake.ParBrake;
		MC_BR_BrakeSetPar_AcpAx_1();
		
		// Finish when done
		IF MC_BR_BrakeSetPar_AcpAx_1.Done OR MC_BR_BrakeSetPar_AcpAx_1.Error THEN
			// Transfer error id, reset funtion block, reset command
			AxisBrake.ErrId := MC_BR_BrakeSetPar_AcpAx_1.ErrorID;
			
			MC_BR_BrakeSetPar_AcpAx_1.Execute := 0;
			MC_BR_BrakeSetPar_AcpAx_1();
			
			AxisBrake.CmdSetPar := FALSE;
		END_IF
	END_IF
	
	// --------------------------------------------------------------------------
	// Open or close brake
	IF AxisBrake.CmdOpen OR AxisBrake.CmdClose THEN
		CASE StateOpenClose OF
				// --------------------------------------------------------------------------
				// Set brake state
			STATE_OPEN_CLOSE:
				// Preset function block
				MC_BR_BrakeOperation_1.Execute := 1;
				MC_BR_BrakeOperation_1.Axis := ADR(AxisBrake.ParAxis);
				IF AxisBrake.CmdOpen THEN
					MC_BR_BrakeOperation_1.Command := mcBRAKE_OPEN;
				ELSE
					MC_BR_BrakeOperation_1.Command := mcBRAKE_CLOSE;
				END_IF
				MC_BR_BrakeOperation_1();
		
				// Finish when done
				IF MC_BR_BrakeOperation_1.Done OR MC_BR_BrakeOperation_1.Error THEN
					// Transfer error id, reset funtion block, reset command
					AxisBrake.ErrId := MC_BR_BrakeOperation_1.ErrorID;
			
					MC_BR_BrakeOperation_1.Execute := 0;
					MC_BR_BrakeOperation_1();
			
					// Abort when error
					IF MC_BR_BrakeOperation_1.Error THEN
						AxisBrake.CmdOpen := FALSE;
						AxisBrake.CmdClose := FALSE;
					ELSE
						StateOpenClose := STATE_STATUS;
					END_IF
				END_IF
				// --------------------------------------------------------------------------
				// Get brake status
			STATE_STATUS:
				// Preset function block
				MC_BR_BrakeOperation_1.Execute := 1;
				MC_BR_BrakeOperation_1.Axis := ADR(AxisBrake.ParAxis);
				MC_BR_BrakeOperation_1.Command := mcBRAKE_GET_STATUS;
				MC_BR_BrakeOperation_1();
		
				// Finish when done
				IF MC_BR_BrakeOperation_1.Done OR MC_BR_BrakeOperation_1.Error THEN
					// Transfer error id, status, reset funtion block, reset command
					AxisBrake.ErrId := MC_BR_BrakeOperation_1.ErrorID;
					AxisBrake.StaBrake := MC_BR_BrakeOperation_1.BrakeStatus;
			
					MC_BR_BrakeOperation_1.Execute := 0;
					MC_BR_BrakeOperation_1();
			
					AxisBrake.CmdOpen := FALSE;
					AxisBrake.CmdClose := FALSE;
					
					StateOpenClose := STATE_OPEN_CLOSE;
				END_IF
		END_CASE;

	END_IF
	
END_ACTION
