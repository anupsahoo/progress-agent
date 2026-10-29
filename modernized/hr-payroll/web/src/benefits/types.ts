// Benefits: generated from the sports2000 schema. The benefits table contains employee benefits.
// Primary key: EmpNum

export interface Benefits {
  /** Emp No. ABL integer, format "zzzzzzzzz9". */
  EmpNum: number;
  /** Health Care. ABL character, format "x(8)". */
  HealthCare?: string | null;
  /** Life Insurance. ABL integer, format "$>>,>>>,>>>". */
  LifeInsurance?: number | null;
  /** Pension401K. ABL integer, format ">>,>>9". */
  Pension401K?: number | null;
  /** Stock Purchase. ABL integer, format ">>,>>9". */
  StockPurchase?: number | null;
  /** Medical Spending. ABL integer, format ">>,>>9". */
  MedicalSpending?: number | null;
  /** Dependent Care. ABL integer, format ">>,>>9". */
  DependentCare?: number | null;
  /** Optimistic concurrency token. Replaces EXCLUSIVE-LOCK from the ABL program. */
  version?: number;
}

export type BenefitsKey = { EmpNum: number };

export const benefitsLabels: Record<string, string> = {
  EmpNum: "Emp No",
  HealthCare: "Health Care",
  LifeInsurance: "Life Insurance",
  Pension401K: "Pension401K",
  StockPurchase: "Stock Purchase",
  MedicalSpending: "Medical Spending",
  DependentCare: "Dependent Care",
};
