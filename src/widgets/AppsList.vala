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
using Gtk;

namespace Wineglass {

    public class AppsList : Gtk.ListBox {

        public signal void empty (bool is_empty);
        private int children_number = 0;

        public AppsList (string[] folders) {
            foreach (string folder in folders) {
                NewEntry (folder);
            }

            if (children_number == 0) {
                empty (true);
            }
        }

        public int get_children_num () {
            print (children_number.to_string());
            return children_number;
        }

        public void NewEntry (string AppName) {
            var row = new Gtk.ListBoxRow ();
            var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            hbox.set_name (AppName);
            hbox.set_margin_top (10);
            hbox.set_margin_bottom (10);
            row.add (hbox);

            row.set_name (AppName + "_row");

            var label = new Gtk.Label (AppName);
            hbox.pack_start (label, false, false, 10);

            var trashButton = new Gtk.Button.from_icon_name ("user-trash-symbolic", Gtk.IconSize.MENU);
            trashButton.clicked.connect (RemoveEntry);
            trashButton.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            hbox.pack_end (trashButton, false, false, 10);

            var settingsButton = new Wineglass.SettingsButton (row, this);
            hbox.pack_end (settingsButton, false, false, 0);

            empty (false);
            children_number++;

            this.add (row);
            this.show_all();
        }

        public string getSelectedPrefix () {
            return (this.get_selected_row ().get_name ().replace ("_row", "") + "\n");
        }

        private void RemoveEntry (Gtk.Button sender) {
            try {
                Actions.remove_prefix (sender.get_parent ().get_name ());
                this.remove(sender.get_parent ().get_parent ());
                children_number--;
                if (children_number == 0) {
                    empty (true);
                }
            } catch (RunError e) {
                //Do something here somehow
                print ("error removing prefix: " + e.message);
            }
        }

    }
}
