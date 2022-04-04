import sublime_plugin


class CompetiveProgrammingCommand(sublime_plugin.WindowCommand):

    def run(self):
        self.window.new_file()

        settings = self.window.active_view().settings()
        settings.set("font_size", 35)

        self.window.run_command(
            "set_build_system",
            {"file": "Packages/User/competive_programming.sublime-build"}
        )

        self.window.run_command(
            "set_file_type",
            {"syntax": "Packages/C++/C++.tmLanguage"}
        )

        self.window.run_command(
            "insert_snippet",
            {"contents": "#include <bits/stdc++.h>\n\n" +
             "using namespace std;\n\n" +
             "int main(int argc, char *argv[]) {" +
             "\n    ${0:$SELECTION}\n    return 0;\n}"}
        )
