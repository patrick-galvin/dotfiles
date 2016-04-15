#!/bin/bash 
DecVal=150 
MinVal=0 
read -r CurrVal < "/sys/class/backlight/intel_backlight/brightness"
NewVal=$(($CurrVal - $DecVal)); 
echo $NewVal 
ThresholdVal=$(($NewVal>$MinVal?$NewVal:$MinVal)) 
echo -n $ThresholdVal | sudo tee /sys/class/backlight/intel_backlight/brightness 
logger "[ACPI] brightnessdown |$CurrVal<nowiki>| |</nowiki>$NewVal| |$ThresholdVal|"
