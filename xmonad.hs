import XMonad 
import XMonad.Config.Gnome

import qualified XMonad.StackSet as W
import XMonad.Util.WorkspaceCompare
import XMonad.Operations
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.AppendFile
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.Tabbed
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

myLayout = ResizableTall 1 (3/100) (1/2) [] ||| Mirror tiled ||| (tabbed shrinkText myTabConfig)
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
          xmonad $ defaultConfig {
            terminal    = "rxvt"
            , workspaces = myWorkspaces
            , layoutHook = smartBorders (avoidStruts $ myLayout)
            , manageHook = myManageHook
            , logHook = takeTopFocus >> (dynamicLogWithPP $ myLogHook statusBarPipe)
            , startupHook = setWMName "LG3D"
          } `additionalKeysP` myKeys

myTabConfig = defaultTheme { 
                 fontName = "Monospace"
                 , activeTextColor = "#00ff00"
                 , activeColor = "#989898"
              }

myManageHook = composeAll [
    manageHook gnomeConfig
    , isFullscreen --> doFullFloat
    , className =? "Mumbles" --> doFloat
  ]

myXPConfig = defaultXPConfig

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

notesPath = "/home/samuel/Dropbox/NOTES"

myKeys = 
	[   
            ("M-r", shellPrompt myXPConfig)
            , ("M-f", spawn "firefox")
            , ("M-n", appendFilePrompt defaultXPConfig notesPath)
            , ("M-S-n", spawn $ "rxvt -e vi " ++ notesPath)
            , ("M-c", spawn "google-chrome")
            , ("M-e", spawn "/home/samuel/bin/explore")
            , ("M-S-t", spawn "mate-system-monitor")
            , ("M-a", sendMessage MirrorShrink)
            , ("M-z", sendMessage MirrorExpand)
            , ("M-S-<Tab>", moveTo Prev myInterestingWSType)
            , ("M-<Tab>", moveTo Next myInterestingWSType)
            , ("M-m", spawn "/home/samuel/bin/soundToggle")
            , ("M-<Down>", spawn "amixer set Master 5%-")
            , ("M-<Up>", spawn "amixer set Master 5%+")
            , ("M-p", spawn "rhythmbox-client --play-pause")
	]

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

myNormalBGColor     = "#111111"
myFocusedBGColor    = "#e8e8e8"
myNormalFGColor     = "#989898"
myFocusedFGColor    = "#b8b8b8"
myUrgentFGColor     = "#667C26"
myUrgentBGColor     = myNormalBGColor
mySeperatorColor    = "#2e3436"

myLogHook = myDzenPP

myDzenPP h = defaultPP 
              {
                ppCurrent = wrap ("^fg(#ffff99)^bg(" ++ myUrgentBGColor ++ ")^p(4)[") "]^p(4)^fg()^bg()",
                ppUrgent = wrap ("^fg(" ++ myUrgentFGColor ++ ")^bg(" ++ myUrgentBGColor ++ ")^p(4)") "^p(4)^fg()^bg()",
                ppVisible = wrap "(" ")",
                ppSep     = "^fg(" ++ mySeperatorColor ++ ")^r(3x3)^fg()",
                ppTitle   = wrap (" ^fg(" ++ myFocusedFGColor ++ ")") "^fg()" ,
                ppOutput  = hPutStrLn h
              }
