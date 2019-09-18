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

public errordomain RunError {
    PREFIX_CREATION_FAILED,
    PREFIX_DELETION_FAILED,
    COMMAND_FAILED
}

public errordomain FileChooserError {
    USER_CANCELED
}

namespace Wineglass {
    public abstract class Actions {

        public static string ChooseFile () throws FileChooserError {
            var file = new Gtk.FileChooserDialog (
                "Open", null,
                Gtk.FileChooserAction.OPEN,
                "Cancel", Gtk.ResponseType.CANCEL,
                "Open", Gtk.ResponseType.ACCEPT);

            var exe_filter = new Gtk.FileFilter ();
            exe_filter.set_filter_name ("Windows executables");
            exe_filter.add_mime_type ("application/x-dosexec");
            exe_filter.add_mime_type ("application/x-ms-dos-executable");
            exe_filter.add_mime_type ("application/x-msi");

            file.add_filter (exe_filter);

            string name;

            if (file.run () == Gtk.ResponseType.ACCEPT) {
                name = file.get_filename ();
            } else {
                file.destroy ();
                throw new FileChooserError.USER_CANCELED ("User canceled file choosing");
            }

            file.destroy ();
            return name;
        }

        private static void runAction (string command) throws RunError {
            run.begin (command,
            (obj, res) => {
                int status = run.end (res);
                if (status != 0) {
                    throw new RunError.COMMAND_FAILED ("command `" + command + "' exited ungracefully");
                }
            });
        }

        public static void winecfg (string prefix_name) throws RunError {
            runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine winecfg");
        }

        public static void regedit (string prefix_name) throws RunError {
            runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine regedit");
        }

        public static void winetricks (string prefix_name) throws RunError {
            runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " winetricks");
        }

        public static void cmd (string prefix_name) throws RunError {
            runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine start cmd.exe");
        }

        public static void taskmgr (string prefix_name) throws RunError {
            runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine taskmgr");
        }

        public static void open_C (string prefix_name) throws RunError {
            runAction ("xdg-open " + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + "");
        }

        public static void exe (string prefix_name, string exe_path) throws RunError {
            try {
                if (exe_path.has_suffix (".msi")) {
                    runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine msiexec /i '" + exe_path + "'");
                    stdout.printf ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine msiexec /i '" + exe_path + "'\n");
                } else {
                    runAction ("WINEPREFIX=" + GLib.Environment.get_home_dir () + "/.wineprefixes/" + prefix_name + " wine '" + exe_path + "'");
                }

            } catch (RunError e) {
                throw e;
            }
        }

        public static void create_prefix (string name) throws RunError {
            //create a wine prefix here
            var home = GLib.Environment.get_home_dir ();
            var prefixdir = home + "/.wineprefixes/" + name;
            var command = "mkdir \"" + prefixdir + "\" && WINEPREFIX=\"" + prefixdir + "\" wine wineboot ";
            run.begin(command,
            (obj, res) => {
                int status = run.end (res);
                if (status != 0) {
                    throw new RunError.PREFIX_CREATION_FAILED ("Wineprefix creation failed with error code: " + status.to_string ());
                }
            });
            //HANDLE ERRORS!
        }

        private static async int run (string command) {
            SourceFunc callback = run.callback;
            int execCode = 0;

            ThreadFunc<bool> runCommand = () => {
                execCode = Posix.system (command);
                Idle.add((owned) callback);
                return true;
            };
            new Thread<bool>(command, runCommand);

            yield;
            return execCode;
        }

        public static void remove_prefix (string name) throws RunError {
            string directory = GLib.Environment.get_home_dir () + "/.wineprefixes/" + name;
            run.begin ("rm -rf " + directory + "", (obj, res) => {
                int status = run.end (res);
                if (status != 0) {
                    throw new RunError.PREFIX_DELETION_FAILED ("Failed to delete prefix folder: rm return non-zero exit code " + (string) status);
                }
            });
        }

        public static string[] get_folders (string directory) {
            try {
                var i = 0;
            	Dir dir = Dir.open (directory, 0);
        		string? name = null;

        		while ((name = dir.read_name ()) != null) {
        			string path = Path.build_filename (directory, name);
        			if (FileUtils.test (path, FileTest.IS_DIR)) {
                        i++;
        			}

                }

                dir.rewind ();
                var names = new string[i];
                i = 0;

        		while ((name = dir.read_name ()) != null) {
        			string path = Path.build_filename (directory, name);
        			if (FileUtils.test (path, FileTest.IS_DIR)) {
                        names[i++] = name;
        			}

                }

                return names;
            } catch (FileError e) {
                if (! FileUtils.test (directory, FileTest.IS_DIR)) {
                    File file = File.new_for_path (directory);
                    try {
                        file.make_directory ();
                        return {};
                    } catch (Error e) {
                        return {};
                    }
                }
                return {};
            }
        }

        public static string create_prefix_from_exe (string exe_path) throws RunError {
            if (!(exe_path.has_suffix (".exe")) && !(exe_path.has_suffix (".msi")))
                return "";

            var name_arr = exe_path.split ("/");
            var name = name_arr [name_arr.length-1];
            name = name [0: name.length-4];
            name = make_name_legal (name.replace("%20", " ").replace("file://", ""));
            if (name.has_suffix ("_"))
                name = name [0:name.length-1];

            var home = GLib.Environment.get_home_dir ();
            var prefixdir = home + "/.wineprefixes/" + name;
            var command = "mkdir \"" + prefixdir + "\"";
            run.begin(command,
            (obj, res) => {
                int status = run.end (res);
                if (status != 0) {
                    throw new RunError.PREFIX_CREATION_FAILED ("Wineprefix creation failed with error code: " + status.to_string ());
                }
                exe (name, exe_path);
            });

            return name;
        }

        private static string make_name_legal (string name) {
            try {
                var regex = new Regex ("[^A-za-z_]");
                var underscore_regex = new Regex ("[ \\-\\.]");
                name = underscore_regex.replace (name, name.length, 0, "_");
                return regex.replace (name, name.length, 0, "");
            } catch (RegexError e) {
                error (e.message);
            }
        }

    }
}
