import tempfile
import subprocess
import os

import sublime
import sublime_plugin


class CompetiveProgrammingBuildCommand(sublime_plugin.WindowCommand):

    def parseSetting(self, **kwargs):
        self.workdir = kwargs.get('workdir', tempfile.gettempdir())
        self.input_filename = kwargs.get('input_filename', 'test.txt')
        self.input_path = os.path.join(self.workdir, self.input_filename)
        if not os.path.isfile(self.input_path):
            with open(self.input_path, "w", encoding="UTF-8"):
                pass

        commands = kwargs.get('commands')
        error = 'competive_programming plugin error: '

        if os.stat(self.input_path).st_size == 0:
            self.createInputView()
            raise Exception(
                "%s %s file is empty!" % (error, self.input_path)
            )

        if commands and 'build' in commands and 'run' in commands:
            self.build_cmd = commands['build']
            cmd_obj = commands['run']
            if 'cmd' not in cmd_obj:
                raise Exception(
                    error +
                    '"commands" setting invalid, ' +
                    ' cmd is undefined in "run" setting'
                )
            self.run_cmd = cmd_obj['cmd']
            self.run_cmd_timeout = 5
            if 'timeout_sec' in cmd_obj:
                self.run_cmd_timeout = cmd_obj['timeout_sec']
        else:
            raise Exception(
                error +
                '"commands" setting invalid, "build" or "run" undefined'
            )

        if 'file_ext' not in kwargs:
            raise Exception(
                error + '"file_ext" key is undefined '
            )
        else:
            self.file_ext = '.' + kwargs.get('file_ext')

    def createPanel(self):
        self.panel = self.window.create_output_panel('exec')
        self.panel.settings().set("font_size", 40)
        self.window.run_command('show_panel', {'panel': 'output.exec'})

    def createViews(self):
        self.code_view = self.window.active_view()
        self.input_view = self.window.open_file(self.input_path)
        self.input_view.settings().set("font_size", 35)
        self.window.focus_view(self.code_view)

    def createInputView(self):
        self.input_view = self.window.open_file(self.input_path)
        self.window.focus_view(self.input_view)

    def output_msg(self, msg):
        self.panel.run_command('append', {'characters': msg + '\n'})

    def saveCodeBuffer(self):
        with tempfile.NamedTemporaryFile(
             mode='w+', suffix=self.file_ext, delete=False) as f:
            contents = self.code_view.substr(
                sublime.Region(0, self.code_view.size())
            )
            f.write(contents)
        self.output_msg('saved file to ' + f.name)
        return f.name

    def saveInputBuffer(self):
        if self.input_view:
            self.input_view.run_command('save')

    def run_compile(self, filePath):
        cmd = self.build_cmd.replace('$file', filePath)
        self.output_msg('Running: %s' % cmd)

        try:
            output = subprocess.check_output(
                cmd,
                stdin=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                cwd=self.workdir, shell=True
            ).decode('utf-8')
        except subprocess.CalledProcessError as e:
            self.output_msg(e.output.decode('utf-8'))
            raise e
        if len(output) > 0:
            self.output_msg(output)

    def run_compile_result(self, filePath):
        cmd = self.run_cmd.replace('$file', filePath)
        self.output_msg('Running: %s' % cmd)

        inputstring = ''
        with open(self.input_path) as f:
            inputstring = ''.join(f.readlines())

        proc = subprocess.Popen(
            cmd.split(' '),
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
        try:
            output, _ = proc.communicate(
                input=bytes(inputstring, 'utf-8'),
                timeout=self.run_cmd_timeout
            )
            self.output_msg(output.decode('utf-8'))
        except subprocess.TimeoutExpired as e:
            self.output_msg('Timed out after %d seconds' % e.timeout)
            proc.terminate()

    def run(self, **kwargs):
        self.createPanel()

        try:
            self.parseSetting(**kwargs)
        except Exception as e:
            self.output_msg(str(e))
            self.output_msg("setting json is following.")
            self.output_msg(str(kwargs))
            return

        self.createViews()
        sourceCodePath = self.saveCodeBuffer()

        try:
            self.run_compile(sourceCodePath)
            self.output_msg('Build Success!')
            self.saveInputBuffer()
            self.run_compile_result(sourceCodePath)
        except subprocess.CalledProcessError:
            self.output_msg('Build Failed.')
        finally:
            if os.path.exists(sourceCodePath):
                os.remove(sourceCodePath)
