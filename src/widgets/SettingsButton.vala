/*
* Copyright (c) {{yearrange}} Alex ()
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Alex Angelou <>
*/
using Granite;
using Granite.Widgets;

namespace Wineglass {
    public class SettingsButton : Gtk.MenuButton {

        private Menu menu = new Menu ();

        public SettingsButton (Gtk.ListBoxRow row, Gtk.ListBox list) {
            this.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            menu.insert (1, "wine configuration", "app.winecfg");
            menu.insert (2, "registry editor", "app.regedit");
            menu.insert (3, "winetricks", "app.winetricks");
            menu.insert (4, "command line", "app.cmd");
            //menu.insert (5, "shortcuts", "app.shortcuts");
            menu.insert (6, "open prefix directory", "app.c_dir");
            menu.insert (7, "Run .exe file", "app.exe");

            this.set_menu_model (menu);
            this.clicked.connect (() => {
                list.select_row (row);
            });
        }

        public string getName (string name) {
            return this.get_parent ().get_name ();
        }

    }
}
