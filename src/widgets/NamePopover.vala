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
    public class NamePopover : Gtk.Popover {

        public NamePopover (Gtk.Widget Relative, Wineglass.AppsList AppsList) {
            var NameEntry = new Gtk.Entry ();
            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            vbox.pack_start (NameEntry, true, true, 0);

            NameEntry.set_margin_top (10);
            NameEntry.set_margin_bottom (10);
            NameEntry.set_margin_start (10);
            NameEntry.set_margin_end (10);

            var errorLabel = new Gtk.Label (_("You can only use\n latin characters,\n numbers and '_'"));
            errorLabel.set_margin_bottom (10);
            vbox.pack_start (errorLabel, true, true, 0);
            errorLabel.set_no_show_all (true);
            errorLabel.hide ();
            this.add (vbox);

            NameEntry.activate.connect (() => {
                try {
                    var regex = new Regex ("^[A-Za-z1-9_]+$");
                    if (regex.match (NameEntry.get_text ())) {
                        this.popdown ();
                        errorLabel.hide ();
                        try {
                            Actions.create_prefix (NameEntry.get_text ());
                            AppsList.NewEntry (NameEntry.get_text ());
                        } catch (RunError e) {
                            Application.ErrorToast.title = "failed to create new wineprefix called " + NameEntry.get_text ();
                            Application.ErrorToast.send_notification ();
                            print (e.message);
                        }
                    } else {
                        errorLabel.show ();
                    }
                } catch (RegexError e) {
                    this.popdown ();
                    print ("Regex testing error: " + e.message);
                }
            });

            this.set_relative_to (Relative);
        }
        
        public void showup () {
            this.popup();
            this.show_all();
        }

    }
}
