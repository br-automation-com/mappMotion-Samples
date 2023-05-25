ACTION AxisConfigSample:
	// Axis base type 
	AxisCfg.ParAxis.BaseType.Type := mcABT_ROT;
	AxisCfg.ParAxis.BaseType.Rotary.MeasurementResolution := 0.01;
	AxisCfg.ParAxis.BaseType.Rotary.MeasurementUnit := mcCLRU_DEG;
	AxisCfg.ParAxis.BaseType.Rotary.CountDirection := mcCCD_STD;
	
	// Movement limits
	AxisCfg.ParAxis.MovementLimits.Internal.Acceleration.Basic.Acceleration := 10000;
	AxisCfg.ParAxis.MovementLimits.Internal.Deceleration.Basic.Deceleration := 10000;
	AxisCfg.ParAxis.MovementLimits.Internal.Velocity.Basic.Velocity := 500;
	
END_ACTION