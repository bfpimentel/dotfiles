import { PerScreen } from "halo";
import config from "@/dashboard/config";
import { Dashboard } from "@/dashboard/Dashboard";

// One dashboard, on the main display (macOS display index 1).
export default () => (
  <PerScreen>
    {(screen) => screen.index === 1 && <Dashboard screen={screen} config={config} />}
  </PerScreen>
);
