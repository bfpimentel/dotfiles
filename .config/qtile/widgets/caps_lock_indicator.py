import re
import subprocess
from libqtile.widget import base

class CapsLockIndicator(base.ThreadPoolText):
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [('update_interval', 0.5, 'Update Time in seconds.')]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(CapsLockIndicator.defaults)

    def get_indicator_status(self):
        try:
            output = self.call_process(['xset', 'q'])
        except subprocess.CalledProcessError as err:
            output = err.output.decode()

        if output.startswith("Keyboard"):
            return re.findall(r"Caps\s+Lock:\s*(\w*)", output)[0] == 'on'

    def poll(self):
        is_on = self.get_indicator_status()
        indicator = ''
        if is_on:
            indicator = '[A]'
        return indicator
