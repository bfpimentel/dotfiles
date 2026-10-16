import { PerScreen } from "halo";
import { Clipboard } from "@/dashboard/Clipboard";
import { clipboardHistory } from "@/dashboard/clipHistory";
import config from "@/dashboard/config";
import { Dashboard } from "@/dashboard/Dashboard";

const history = clipboardHistory(config.clipboard);

export default () => (
  <PerScreen>
    {(screen) =>
      screen.index === 1 && (
        <>
          <Dashboard screen={screen} config={config} />
          <Clipboard screen={screen} config={config} history={history} />
        </>
      )
    }
  </PerScreen>
);
