ACTION AxisConfigSample:
	// Drive controller configuration 
	AxisDriveCfg.ParDrive.Controller.Mode.PositionControllerTorqueFf.Position.ProportionalGain := 200;
	AxisDriveCfg.ParDrive.Controller.Mode.PositionControllerTorqueFf.Position.IntegrationTime := 0;
	AxisDriveCfg.ParDrive.Controller.Mode.PositionControllerTorqueFf.Position.TotalDelayTime := 0.0004;
	
END_ACTION