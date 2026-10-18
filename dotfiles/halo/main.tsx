import { PerScreen } from "halo";
import { Clipboard } from "@/dashboard/Clipboard";
import { clipboardHistory } from "@/dashboard/clipHistory";
import config from "@/dashboard/config";
import { Dashboard } from "@/dashboard/Dashboard";
import { FileShelf } from "@/dashboard/FileShelf";
import { fileShelf } from "@/dashboard/shelf";

const history = clipboardHistory(config.clipboard);
const shelf = fileShelf();

export default () => (
  <PerScreen>
    {(screen) =>
      screen.index === 1 && (
        <>
          <Dashboard screen={screen} config={config} />
          <Clipboard screen={screen} config={config} history={history} />
          <FileShelf screen={screen} theme={config.theme} shelf={shelf} />
        </>
      )
    }
  </PerScreen>
);
