import type { WidgetProps } from "halo";
import { FileShelf } from "@/shelf/FileShelf";
import { shelf } from "@/shelf/store";

export default ({ screen }: WidgetProps) => <FileShelf screen={screen} shelf={shelf} />;
