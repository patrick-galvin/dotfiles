import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad
import XMonad
import System.Exit

import XMonad.Actions.Submap
import XMonad.Layout.Tabbed
import XMonad.Layout.Circle
import XMonad.Layout.ThreeColumns
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.Window
import XMonad.Prompt.Workspace
import XMonad.Prompt.Input
import XMonad.Actions.DynamicWorkspaces
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.SetWMName
import XMonad.Actions.SpawnOn

import XMonad.Layout.Spiral
import XMonad.Util.Scratchpad

import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import qualified Data.Map as M


myFont          = "-*-tamsyn-medium-*-normal-*-11-*-*-*-*-*-*-*"
myWorkspaces    = ["1:main","2:dev","3:www","4:emacs","5:admin", "6:ssh"]
myXmonadBar = "dzen2 -x '0' -y '0' -h '24' -w '800' -ta 'l' -fg '"++foreground++"' -bg '"++background++"' -fn "++myFont
myStatusBar = "conky -c /home/$USER/.xmonad/.conky_dzen | dzen2 -x '800' -w '1000' -h '24' -ta 'r' -bg '" ++background++"' -fg '"++foreground++"' -y '0' -fn "++myFont

background      = "#002b36"
foreground      = "#ffffff"
active          = "#ffee55"
inactive        = "#b2b2b2"
nowindow        = "#404040"
nborder         = "#343638"
aborder         = "#111111"

myLayout = avoidStruts $
           tiled
           ||| Mirror tiled
           ||| Full
           ||| threeCol
--           ||| spiral (4/3)
  where
     tiled   = Tall nmaster delta ratio
     threeCol = ThreeCol nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 2/100

myLogHook h = dynamicLogWithPP $ defaultPP
    { ppCurrent         = dzenColor "#303030" "#909090" . pad 
    , ppHidden          = dzenColor "#909090" "" . pad 
    , ppHiddenNoWindows = dzenColor "#606060" "" . pad 
    , ppLayout          = dzenColor "#909090" "" . pad 
    , ppUrgent          = dzenColor "#ff0000" "" . pad . dzenStrip
    , ppTitle           = shorten 100
    , ppWsSep           = ""
    , ppSep             = "  "
    , ppOutput          = hPutStrLn h
    }

myManageHook = composeAll
    [ className =? "chromium-browser" --> doShift "3:www",
      className =? "emacs" --> doShift "4:emacs"]

myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

newKeys conf@(XConfig {XMonad.modMask = modm}) = [
  ((modm, xK_c), spawn "chromium 'https://calendar.google.com'"),
  ((modm, xK_m), spawn "chromium 'https://mail.google.com'")
   ]

main = do
       dzenLeftBar <- spawnPipe myXmonadBar
       dzenRightBar <- spawnPipe myStatusBar
       xmonad $ defaultConfig
	{ 
	 modMask		= mod4Mask
	 , terminal		= "urxvt"
         , manageHook           = manageSpawn <+> myManageHook <+> manageHook defaultConfig
	 , startupHook		= do
                                        setWMName "LG3D"
                                        spawnOn "3:www" "chromium"
                                        spawnOn "5:admin" "keepass2"
                                        spawnOn "4:emacs" "emacs"
                                        spawnOn "1:main" "urxvt"
         
	 , layoutHook         	= myLayout
	 , logHook 		= myLogHook dzenLeftBar
         , workspaces            = myWorkspaces
	 , keys                  = myKeys
	}
