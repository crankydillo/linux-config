import XMonad
import XMonad.Config.Gnome

import XMonad.StackSet hiding (filter)
import XMonad.Util.WorkspaceCompare
import XMonad.Operations
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders

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
            terminal    = "urxvt"
            , layoutHook = smartBorders (avoidStruts $ myLayout)
            , keys =  newKeys
            , manageHook = myManageHook
            , logHook = dynamicLogWithPP $ myLogHook statusBarPipe 
            , startupHook = setWMName "LG3D"
          }
          
          

myManageHook = composeAll [
    manageHook gnomeConfig
    , isFullscreen --> doFullFloat
  ]

myXPConfig = defaultXPConfig {
      font = "-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*"
  }

newKeys x = M.union (M.fromList (myKeys x)) (keys gnomeConfig x)

myKeys x = 
	[   
	((modMask x, xK_r), shellPrompt myXPConfig)
	, ((modMask x, xK_a), sendMessage MirrorShrink)
	, ((modMask x, xK_z), sendMessage MirrorExpand)
	, ((modMask x, xK_Left), prevWS)
	, ((modMask x, xK_Right), nextWS)
	, ((modMask x .|. shiftMask, xK_Tab), moveTo Prev myInterestingWSType)
	, ((modMask x, xK_Tab), moveTo Next myInterestingWSType)
	]   

-- I want to use alt-tab and alt-shift-tab to cycle between the non-empty
-- workspaces that I typically use.
myInterestingWSType = WSIs (return ((\w -> (read (tag w) :: Int) < 7 && isJust (stack w))))

myStatusBar = "dzen2 -x 1 -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -fg '#989898' -h 16 -y 1064 -w 1000 -sa c -ta l"

myNormalBGColor     = "#111111"
myFocusedBGColor    = "#e8e8e8"
myNormalFGColor     = "#989898"
myFocusedFGColor    = "#b8b8b8"
myUrgentFGColor     = "#667C26"
myUrgentBGColor     = myNormalBGColor
mySeperatorColor    = "#2e3436"

-- myLogHook h = dzenPP ...
myLogHook h = defaultPP 
      {
        ppCurrent = wrap "[" "]",
        ppUrgent = wrap ("^fg(" ++ myUrgentFGColor ++ ")^bg(" ++ myUrgentBGColor ++ ")^p(4)") "^p(4)^fg()^bg()",
        ppVisible = wrap "(" ")",
        ppSep     = "^fg(" ++ mySeperatorColor ++ ")^r(3x3)^fg()",
        ppTitle   = wrap (" ^fg(" ++ myFocusedFGColor ++ ")") "^fg()" ,
        ppOutput  = hPutStrLn h
}
