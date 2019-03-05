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
    public class Headerbar : Gtk.HeaderBar {

        public signal void ChangedSearch (string query);

        public Gtk.Button addEntryButton = new Gtk.Button.from_icon_name ("list-add-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        private Gtk.SearchEntry Search = new Gtk.SearchEntry ();
        private Gtk.Revealer revealer = new Gtk.Revealer ();

        public Headerbar () {
            addEntryButton.set_tooltip_text (_("Create a new prefix"));

            Search.valign = Gtk.Align.CENTER;
            Search.set_margin_start (10);
            Search.hexpand = true;
            Search.set_placeholder_text ("Search for wineprefixes");

            Search.changed.connect(() => {
                ChangedSearch (Search.get_text());
            });

            revealer.add (Search);
            revealer.set_reveal_child (true);
            revealer.set_transition_type (RevealerTransitionType.SLIDE_DOWN);

            this.pack_end (addEntryButton);
            this.set_custom_title(revealer);
            this.get_style_context ().add_class ("compact");
            this.set_show_close_button (true);
        }

        public Gtk.SearchEntry get_search_entry () {
            return Search;
        }

        public void reveal_search (bool reveal) {
            revealer.set_reveal_child (reveal);
        }

        public void search_error (bool query_not_ok) {
            if (query_not_ok && !Search.get_style_context ().has_class ("error")) {
                Search.get_style_context ().add_class ("error");
            } else if (!query_not_ok && Search.get_style_context ().has_class ("error")) {
                Search.get_style_context ().remove_class ("error");
            }
        }

    }
}
