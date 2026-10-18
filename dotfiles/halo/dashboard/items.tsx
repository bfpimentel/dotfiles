import type { Element, Reactive } from "halo";
import type { Accessor } from "halo/signals";

export interface Item {
  id: string;
  title: string;
  subtitle: Reactive<string>;
  icon(selected: Accessor<boolean>): Element;
  badge?(): Element | null;
  run(): void;
  searchable?: boolean;
}
