import { PerScreen } from "halo";
import config from "@/launcher.config";
import { Launcher } from "@/launcher/Launcher";

// One launcher, on the main display (macOS display index 1).
export default () => (
  <PerScreen>
    {(screen) => screen.index === 1 && <Launcher screen={screen} config={config} />}
  </PerScreen>
);
