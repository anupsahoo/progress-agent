// Feedback: generated from the sports2000 schema. The feedback table allows customers to provide feedback about what they like and don't like.
// Primary key: Department

export interface Feedback {
  /** Contact Name. ABL character, format "x(30)". */
  Contact?: string | null;
  /** Company. ABL character, format "x(20)". */
  Company?: string | null;
  /** Email. ABL character, format "x(50)". */
  EmailAddress?: string | null;
  /** Phone. ABL character, format "x(20)". */
  Phone?: string | null;
  /** Fax. ABL character, format "x(20)". */
  Fax?: string | null;
  /** Comments. ABL character, format "x(80)". */
  Comments?: string | null;
  /** Department. ABL character, format "x(15)". */
  Department: string;
  /** Rating. ABL integer, format "9". */
  Rating?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type FeedbackKey = { Department: string };

export const feedbackLabels: Record<string, string> = {
  Contact: "Contact Name",
  Company: "Company",
  EmailAddress: "Email",
  Phone: "Phone",
  Fax: "Fax",
  Comments: "Comments",
  Department: "Department",
  Rating: "Rating",
};
