-- EdgeTx Rx Search v1
-- 2025 05 03
-- by Alexander Gribatskii 

-- This LUA stores and outputs the low and high signal level from the receiver. 
-- Based on these levels, the Tx should beeps from low to high tone depending on the strength of the Rx signal.
-- Haptic uses to display the maximum signal level.
-- To clear saved Min and Max signal levels press and hold enther btn.

-- To install, drop the file into the \SCRIPTS\TELEMETRY folder
-- Then place it on your telemetry screen in the model settings


local uRssiCur = 0
local PowerCur = 0
local PowerMin = 100
local PowerMax = 0
local nextPlayTime = getTime()

 local function run(event)
  lcd.clear()
  lcd.drawText(3, 3, "Rx Search", 0)
  
  --reset telemetry data 
  if event == EVT_ENTER_LONG then
	uRssiCur = 0
	PowerCur = 0
	PowerMin = 100
	PowerMax = 0		
	playHaptic(10, 10)
	playHaptic(10, 10)
  end 	
  
  if getValue("1RSS") ~= 0 then 
	uRssiCur=getValue("1RSS")
    PowerCur= 100+uRssiCur

	if PowerCur < PowerMin then
		PowerMin = PowerCur
	end
	
	if PowerCur > PowerMax then
		PowerMax = PowerCur
		playHaptic(100, 100)
	end
  end
  
  lcd.drawText	(3 , 20, "Power", 0)
  lcd.drawNumber(50, 15, PowerCur, DBLSIZE)
  lcd.drawText	(3 , 40, "RSSI", 0)
  lcd.drawNumber(50, 37, uRssiCur, MIDSIZE)
 
  lcd.drawText(75, 15, "Min",0) 
  lcd.drawText(75, 25, "Max",0) 
 
  lcd.drawNumber(100, 15, PowerMin) 
  
  if PowerMax == PowerCur then  
	lcd.drawNumber(100, 25, PowerMax,FORCE) 
  else
	lcd.drawNumber(100, 25, PowerMax) 
  end 
	
  
  if uRssiCur ~= 0 then   
	  if getTime() >= nextPlayTime then
			if (PowerMax - PowerMin) ~= 0 then
				nextPlayTime = getTime() + 100
				playTone(1800 - (15*(100 - ((PowerCur-PowerMin)/(PowerMax - PowerMin) * 100))), 200, 0, 3, 0, PLAY_NOW)
			end
	  end
  end
end

return {run = run}
