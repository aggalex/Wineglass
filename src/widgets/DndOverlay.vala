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
    public class DndOverlay : Gtk.Overlay {

        public signal void on_esc ();

        public const Gtk.TargetEntry[] targets = {
            {"text/uri-list",0,0}
        };

        public Gtk.Widget background {get; construct;}

        private Gtk.Revealer revealer = new Gtk.Revealer ();

        public DndOverlay (Gtk.Widget background) {
            Object (
                background: background
            );
        }

        construct {
            var image = new Gtk.Image.from_file (Constants.INSTALL_PREFIX + "/share/wineglass/dnd_image.svg");
            image.show ();

            var image_wrapper = new Gtk.Box (Orientation.VERTICAL, 0);
            image_wrapper.get_style_context ().add_class ("dark-bg");
            image_wrapper.pack_start (image, true, true, 0);
            image_wrapper.show ();

            revealer.reveal_child = false;
            revealer.transition_type = RevealerTransitionType.CROSSFADE;
            revealer.add (image_wrapper);
            revealer.no_show_all = true;
            revealer.hide ();
            on_esc.connect (() => {
                revealer.reveal_child = !(revealer.reveal_child);
            });

            drag_dest_set (this, Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
            drag_leave.connect (on_drag_leave);
            drag_motion.connect (on_drag_motion);
            drag_data_received.connect (on_drag_data_received);

            this.add (background);
            this.add_overlay (revealer);
            this.show_all ();
            this.show ();
        }

        public bool on_drag_motion (Gdk.DragContext context, int x, int y, uint time) {
            if (revealer.reveal_child == true) return true;
            revealer.show ();
            revealer.reveal_child = true;
            return true;
        }

        public void on_drag_leave (Gdk.DragContext context, uint time) {
            revealer.reveal_child = false;
            revealer.hide ();
        }

        public void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, Gtk.SelectionData data, uint info, uint time) {
            foreach (string uri in data.get_uris ()) {
                uri = uri.replace("%20", " ").replace("file://", "");
                var name = Actions.create_prefix_from_exe (uri);
                if (name != "" && background is MainBox)
                    ((MainBox) background).AppsList.NewEntry (name);
            }
            Gtk.drag_finish (drag_context, true, false, time);
        }

    }
}
