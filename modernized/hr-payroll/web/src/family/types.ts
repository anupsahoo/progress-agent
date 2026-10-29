// Family: generated from the sports2000 schema. The family table tracks an employee's family
// Primary key: EmpNum, RelativeName

export interface Family {
  /** Emp No. ABL integer, format "zzzzzzzzz9". */
  EmpNum: number;
  /** Relative Name. ABL character, format "x(15)". */
  RelativeName: string;
  /** Relation. ABL character, format "x(15)". */
  Relation?: string | null;
  /** Birthdate. ABL date, format "99/99/9999". */
  Birthdate?: string | null;
  /** Covered On Benefits. ABL logical, format "yes/no". */
  CoveredOnBenefits?: boolean | null;
  /** Benefit Date. ABL date, format "99/99/9999". */
  BenefitDate?: string | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type FamilyKey = { EmpNum: number; RelativeName: string };

export const familyLabels: Record<string, string> = {
  EmpNum: "Emp No",
  RelativeName: "Relative Name",
  Relation: "Relation",
  Birthdate: "Birthdate",
  CoveredOnBenefits: "Covered On Benefits",
  BenefitDate: "Benefit Date",
};
