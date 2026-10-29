import type { Element, KeyEvent, Reactive } from "halo";
import type { Accessor } from "halo/signals";

/** What happened after an item ran, for whoever shows it. */
export interface Feedback {
  title: string;
  subtitle?: string;
  symbol?: string;
  app?: string;
}

export interface Item {
  id: string;
  title: string;
  subtitle?: Reactive<string>;
  accessory?: Reactive<string>;
  icon?(selected: Accessor<boolean>): Element;
  badge?(): Element | null;
  run(): void;
  /** Milliseconds before the palette closes after `run`, or `false` to keep it open. Default 170. */
  closeAfter?: number | false;
  actions?: Binding[];
  /** Read just before `run`. */
  feedback?(): Feedback | undefined;
}

export interface Binding {
  key: KeyEvent["key"];
  meta?: boolean;
  ctrl?: boolean;
  alt?: boolean;
  shift?: boolean;
  /** How the keys read in the hints footer, e.g. "⌘⌫". */
  label: string;
  hint: string;
  run(): void;
}

export interface Match {
  score: number;
  indices: number[];
}

export interface Ranked {
  item: Item;
  match: Match;
}

export interface PaletteContext {
  query: Accessor<string>;
  idle: Accessor<boolean>;
  results: Accessor<Ranked[]>;
  selected: Accessor<Item | undefined>;
  close(): void;
}
