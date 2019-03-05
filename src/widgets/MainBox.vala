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
    public class MainBox : Gtk.Stack {

        private Wineglass.AppsList AppsList;

        public MainBox (Wineglass.Headerbar headerbar) {
            this.set_transition_type (Gtk.StackTransitionType.SLIDE_UP_DOWN);

            var Wineprefixes = Actions.get_folders (Environment.get_home_dir () + "/.wineprefixes");

            AppsList = new Wineglass.AppsList (Wineprefixes);
            AppsList.show ();

            this.add_named (AppsList, "AppsList");

            var Welcome = new Granite.Widgets.Welcome (_("No wineprefixes"), _("Wineprefix folder is empty"));
            Welcome.show ();
            var AddButton = Welcome.append ("list-add", _("Create one"), _("Create a new empty wineprefix"));

            var NamePopover = new Wineglass.NamePopover (Welcome.get_button_from_index (AddButton), AppsList);

            Welcome.activated.connect (() => {
                NamePopover.showup ();
            });
            this.add_named (Welcome, "Welcome");

            print (this.get_visible_child_name ());

            if (AppsList.get_children_num() == 0) {
                this.set_visible_child_name ("Welcome");
                headerbar.reveal_search (false);
            } else {
                this.set_visible_child_name ("AppsList");
                headerbar.reveal_search (true);
            }

            print (this.get_visible_child_name ());

            headerbar.ChangedSearch.connect ((query) => {
                AppsList.Search(query);
            });

            AppsList.NoShow.connect ((has_nothing) => {
                headerbar.search_error (has_nothing);
            });

            AppsList.empty.connect ((isEmpty) => {
                print ("Empty/full Signal recieved! " + isEmpty.to_string ());
                if (isEmpty == true) {
                    this.set_visible_child_name ("Welcome");
                    headerbar.reveal_search (false);
                } else {
                    this.set_visible_child_name ("AppsList");
                    headerbar.reveal_search (true);
                }
            });
        }

        public Wineglass.AppsList get_AppsList () {
            return AppsList;
        }

    }
}
