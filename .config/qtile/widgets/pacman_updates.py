from subprocess import CalledProcessError, Popen
from libqtile.widget import base

class PacmanUpdates(base.ThreadedPollText):
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("custom_command", None, "Custom shell command for checking updates (counts the lines of the output)"),
        ("update_interval", 60, "Update interval in seconds."),
        ('execute', None, 'Command to execute on click'),
        ("display_format", "Updates: {updates}", "Display format if updates available"),
        ("colour_no_updates", "ffffff", "Colour when there's no updates."),
        ("colour_have_updates", "ffffff", "Colour when there are updates."),
    ]

    def __init__(self, **config):
        base.ThreadedPollText.__init__(self, **config)
        self.add_defaults(PacmanUpdates.defaults)

        if self.execute:
            self.add_callbacks({'Button1': self.do_execute})

    def _check_updates(self):
        try:
            updates = self.call_process(['pacman', '-Qu'])
        except CalledProcessError:
            updates = ""

        num_updates = str(len(updates.splitlines()))

        self._set_colour(num_updates)
        return self.display_format.format(**{"updates": num_updates})

    def _set_colour(self, num_updates):
        if not num_updates.startswith("0"):
            self.layout.colour = self.colour_have_updates
        else:
            self.layout.colour = self.colour_no_updates

    def poll(self):
        return self._check_updates()

    def do_execute(self):
        self._process = Popen(self.execute, shell=True)
        self.timeout_add(1, self._refresh_count)

    def _refresh_count(self):
        if self._process.poll() is None:
            self.timeout_add(1, self._refresh_count)

        else:
            self.tick()
