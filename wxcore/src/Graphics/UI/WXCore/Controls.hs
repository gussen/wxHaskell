--------------------------------------------------------------------------------
{-| Module      :  Controls
    Copyright   :  (c) Daan Leijen 2003
    License     :  wxWindows

    Maintainer  :  daan@cs.uu.nl
    Stability   :  provisional
    Portability :  portable
-}
--------------------------------------------------------------------------------
module Graphics.UI.WXCore.Controls
    ( 
      -- * Log
      textCtrlMakeLogActiveTarget
    , logDeleteAndSetActiveTarget
      -- * Tree control
    , TreeCookie
    , treeCtrlGetChildCookie, treeCtrlGetNextChild2
    , treeCtrlWithChildren, treeCtrlGetChildren
      -- * Wrappers
    , listBoxGetSelectionList
    ) where

import Graphics.UI.WXCore.WxcTypes
import Graphics.UI.WXCore.WxcDefs
import Graphics.UI.WXCore.WxcClasses
import Graphics.UI.WXCore.Types

import Foreign.Storable
import Foreign.Marshal.Array
import Foreign.Marshal.Utils


-- | Represents the children of a tree control.
data TreeCookie   = TreeCookie (Var Cookie)
data Cookie       = Cookie TreeItem CInt
                  | CookieFirst TreeItem
                  | CookieInvalid

-- | Get a @TreeCookie@ to iterate through the children of tree node.
treeCtrlGetChildCookie :: TreeCtrl a -> TreeItem -> IO TreeCookie
treeCtrlGetChildCookie treeCtrl parent
  = do pcookie <- varCreate (CookieFirst parent)
       return (TreeCookie pcookie)

-- | Get the next child of a tree node. Returns 'Nothing' when
-- the end of the list is reached. This also invalidates the tree cookie.
treeCtrlGetNextChild2 :: TreeCtrl a -> TreeCookie -> IO (Maybe TreeItem)
treeCtrlGetNextChild2 treeCtrl treeCookie@(TreeCookie pcookie)
  = do cookie <- varGet pcookie
       case cookie of
         CookieInvalid    -> return Nothing
         CookieFirst item -> with 0 $ \pint ->
                             do first <- treeCtrlGetFirstChild treeCtrl item pint
                                i     <- peek pint
                                if (treeItemIsOk first)
                                 then do varSet pcookie (Cookie item i)
                                         return (Just first)
                                 else do varSet pcookie (CookieInvalid)
                                         return Nothing
         Cookie parent i  -> with i $ \pint ->
                             do next <- treeCtrlGetNextChild treeCtrl parent pint
                                j    <- peek pint
                                if (treeItemIsOk next)
                                 then do varSet pcookie (Cookie parent j)
                                         return (Just next)
                                 else do varSet pcookie (CookieInvalid)
                                         return Nothing

-- | Iterate on the list of children of a tree node.
treeCtrlWithChildren :: TreeCtrl a -> TreeItem -> (TreeItem -> IO b) -> IO [b]
treeCtrlWithChildren treeCtrl parent f
  = do cookie <- treeCtrlGetChildCookie treeCtrl parent
       let walk acc  = do mbitem <- treeCtrlGetNextChild2 treeCtrl cookie
                          case mbitem of
                            Nothing   -> return (reverse acc)
                            Just item -> do x <- f item
                                            walk (x:acc)
       walk []

-- | Get the children of tree node.
treeCtrlGetChildren :: TreeCtrl a -> TreeItem -> IO [TreeItem]
treeCtrlGetChildren treeCtrl item
  = treeCtrlWithChildren treeCtrl item return

-- | 

-- | Return the current selection in a listbox.
listBoxGetSelectionList :: ListBox a -> IO [Int]
listBoxGetSelectionList listBox
  = do n <- listBoxGetSelections listBox ptrNull 0
       let count = abs n
       allocaArray count $ \carr ->
        do listBoxGetSelections listBox carr count
           xs <- peekArray count carr
           return (map fromCInt xs)

-- | Sets the active log target and deletes the old one.
logDeleteAndSetActiveTarget :: Log a -> IO ()
logDeleteAndSetActiveTarget log
  = do oldlog <- logSetActiveTarget log
       logDelete oldlog
       

-- | Set a text control as a log target.
textCtrlMakeLogActiveTarget :: TextCtrl a -> IO ()
textCtrlMakeLogActiveTarget textCtrl
  = do log <- logTextCtrlCreate textCtrl
       logDeleteAndSetActiveTarget log
       