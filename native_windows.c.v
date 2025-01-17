module mui

#include "@VMODROOT/native/windows_shared_helper.h"
#include "@VMODROOT/native/windows_popup_helper.h"

fn C.CreatePopupMenu() voidptr
fn C.InsertMenuItem(hmenu C.HMENU, id int, idk_wtd bool, item &C.MENUITEMINFO)
fn C.TrackPopupMenu(hmenu C.HMENU, int, int, int, int, voidptr, int) int
fn C.mui_popup_menu_MENUITEMINFO(id int, def bool, disabled bool, checked bool, text &u16) C.MENUITEMINFO
fn C.DestroyMenu(hmenu C.HMENU)
fn C.mui_update_window_pos(hwnd voidptr)

fn (mut app Window) create_popup_menu(the_list []string, x int, y int) int {
	unsafe {
		mut hmenu := C.CreatePopupMenu()
		for id,w in the_list{
			mut item := C.mui_popup_menu_MENUITEMINFO(id+1, false, false, false, w.to_wide())
			C.InsertMenuItem(hmenu, id+1, true, &item)
		}
		C.mui_update_window_pos(app.window_handle())
		output := C.TrackPopupMenu(hmenu, C.TPM_LEFTALIGN | C.TPM_RIGHTBUTTON | C.TPM_RETURNCMD | C.TPM_NONOTIFY, C.mui_window_left+x, C.mui_window_top+y, 0, app.window_handle(), C.NULL)
		C.DestroyMenu(hmenu)
		return output-1
	}
}
