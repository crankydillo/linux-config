import XMonad 
import XMonad.Config.Gnome

import qualified XMonad.StackSet as W --hiding (filter, workspaces)
import XMonad.Util.WorkspaceCompare
import XMonad.Operations
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
--import XMonad.Layout.IndependentScreens
--import XMonad.Layout.Magnifier
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

import XMonad.Util.EZConfig

import XMonad.Hooks.ICCCMFocus

import Data.List
import Data.Monoid
import Data.Maybe (isNothing, isJust)
import qualified Data.Map as M
import System.IO

myLayout = ResizableTall 1 (3/100) (1/2) [] ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

main = do statusBarPipe <- spawnPipe myStatusBar
          --xmonad $ gnomeConfig {
          xmonad $ defaultConfig {
            terminal    = "rxvt"
            --terminal    = "gnome-terminal"
            , workspaces = myWorkspaces
            , layoutHook = smartBorders (avoidStruts $ myLayout)
            --, keys =  newKeys
            , manageHook = myManageHook
            , logHook = takeTopFocus >> (dynamicLogWithPP $ myLogHook statusBarPipe)
            , startupHook = setWMName "LG3D"
          } `additionalKeysP` myKeys

-- bindPPoutput pp h = pp { ppOutput = hPutStrLn h }

{-
pp h s = marshallPP s defaultPP { 
              ppCurrent = wrap "[" "]",
              ppUrgent = wrap ("^fg(" ++ myUrgentFGColor ++ ")^bg(" ++ myUrgentBGColor ++ ")^p(4)") "^p(4)^fg()^bg()",
              ppVisible = wrap "(" ")",
              ppSep     = "^fg(" ++ mySeperatorColor ++ ")^r(3x3)^fg()",
              ppTitle   = wrap (" ^fg(" ++ myFocusedFGColor ++ ")") "^fg()" ,

              ppOutput = hPutStrLn h 
            }
-}
          
myManageHook = composeAll [
    manageHook gnomeConfig
    , isFullscreen --> doFullFloat
    , className =? "Mumbles" --> doFloat
  ]

myXPConfig = defaultXPConfig
{-
myXPConfig = defaultXPConfig {
      font = "-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*"
  }
-}

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myKeys = 
	[   
            ("M-r", shellPrompt myXPConfig)
            , ("M-f", spawn "firefox")
            , ("M-c", spawn "google-chrome")
            , ("M-e", spawn "/home/samuel/bin/explore")
            , ("M-a", sendMessage MirrorShrink)
            , ("M-z", sendMessage MirrorExpand)
            --, ("M-<Left>", prevWS)
            --, ("M-<Right>", nextWS)
            , ("M-S-<Tab>", moveTo Prev myInterestingWSType)
            , ("M-<Tab>", moveTo Next myInterestingWSType)
            --, ("M-m", spawn "amixer set Master toggleMute")
            , ("M-m", spawn "/home/samuel/bin/soundToggle")
            , ("M-<Down>", spawn "amixer set Master 5%-")
            , ("M-<Up>", spawn "amixer set Master 5%+")
            , ("M-p", spawn "rhythmbox-client --play-pause")

            {-
            , ("M-<KP_Equal>", sendMessage MagnifyMore)
            , ("M-<KP_Subtract>", sendMessage MagnifyLess)
            , ((modm .|. controlMask              , xK_o    ), sendMessage ToggleOff  )
            , ((modm .|. controlMask .|. shiftMask, xK_o    ), sendMessage ToggleOn   )
            , ((modm .|. controlMask              , xK_m    ), sendMessage Toggle     )
            -}
	]-- ++ myKeys2

myKeys2 =
    [ (otherModMasks ++ "M-" ++ [key], action tag)
        | (tag, key)  <- zip myWorkspaces "123456789"
        , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
        , ("S-", windows . W.shift)]
    ]

-- I want to use alt-tab and alt-shift-tab to cycle between the non-empty
-- workspaces that I typically use.
myInterestingWSType = WSIs (return ((\w -> (read (W.tag w) :: Int) < 5 && isJust (W.stack w))))

myStatusBar = "dzen2 -x 1 -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -fg '#989898' -h 16 -y 1064 -w 1200 -sa c -ta l" 
--myStatusBar = "dzen2 -x 1 -fg '#989898' -h 16 -y 1064 -w 1200 -sa c -ta l" 

myNormalBGColor     = "#111111"
myFocusedBGColor    = "#e8e8e8"
myNormalFGColor     = "#989898"
myFocusedFGColor    = "#b8b8b8"
myUrgentFGColor     = "#667C26"
myUrgentBGColor     = myNormalBGColor
mySeperatorColor    = "#2e3436"

-- myLogHook h = dzenPP ...
myLogHook = myDzenPP

myDzenPP h = defaultPP 
              {
                ppCurrent = wrap "[" "]",
                ppUrgent = wrap ("^fg(" ++ myUrgentFGColor ++ ")^bg(" ++ myUrgentBGColor ++ ")^p(4)") "^p(4)^fg()^bg()",
                ppVisible = wrap "(" ")",
                ppSep     = "^fg(" ++ mySeperatorColor ++ ")^r(3x3)^fg()",
                ppTitle   = wrap (" ^fg(" ++ myFocusedFGColor ++ ")") "^fg()" ,
                ppOutput  = hPutStrLn h
              }

--bindPPoutput pp h = pp { ppOutput = hPutStrLn h }
