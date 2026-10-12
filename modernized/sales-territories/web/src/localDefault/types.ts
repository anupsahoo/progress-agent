// LocalDefault: generated from the sports2000 schema. The local default table contains default information for the application.
// Primary key: LocalDefNum

export interface LocalDefault {
  /** Country. ABL character, format "x(20)". */
  Country?: string | null;
  /** Region1 Label. ABL character, format "x(15)". */
  Region1Label?: string | null;
  /** Region2 Label. ABL character, format "x(15)". */
  Region2Label?: string | null;
  /** Postal Label. ABL character, format "x(15)". */
  PostalLabel?: string | null;
  /** Postal Format. ABL character, format "x(15)". */
  PostalFormat?: string | null;
  /** Tel Format. ABL character, format "x(15)". */
  TelFormat?: string | null;
  /** Currency Symbol. ABL character, format "x(6)". */
  CurrencySymbol?: string | null;
  /** Date Format. ABL character, format "x(8)". */
  DateFormat?: string | null;
  /** Local Default Num. ABL integer, format "zzzzzzzzz9". */
  LocalDefNum: number;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type LocalDefaultKey = { LocalDefNum: number };

export const localDefaultLabels: Record<string, string> = {
  Country: "Country",
  Region1Label: "Region1 Label",
  Region2Label: "Region2 Label",
  PostalLabel: "Postal Label",
  PostalFormat: "Postal Format",
  TelFormat: "Tel Format",
  CurrencySymbol: "Currency Symbol",
  DateFormat: "Date Format",
  LocalDefNum: "Local Default Num",
};
