#!/bin/bash 

IncVal=150 
read -r MaxVal < "/sys/class/backlight/intel_backlight/max_brightness"
read -r CurrVal < "/sys/class/backlight/intel_backlight/brightness"
NewVal=$(($CurrVal + $IncVal)); 
ThresholdVal=$(($NewVal<$MaxVal?$NewVal:$MaxVal)) 
echo $ThresholdVal 
echo -n $ThresholdVal | sudo tee /sys/class/backlight/intel_backlight/brightness 
logger "[ACPI] brightnessup |$CurrVal| |$NewVal| |$ThresholdVal|"
