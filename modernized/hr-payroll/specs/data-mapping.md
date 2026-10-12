# HR & Payroll: data mapping

ABL field to TypeScript, Pydantic and validation. Generated from `sports2000.df`.

## Employee `employees`

Primary key: `EmpNum` · Indexes: `EmpNo` (primary) (unique), `DeptCode`, `Name` (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `EmpNum` | Emp No | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `LastName` | Last Name | character | `x(25)` | `string` | `str` | at most 25 characters |
| `FirstName` | First Name | character | `x(15)` | `string` | `str` | at most 15 characters |
| `Address` | Address | character | `x(35)` | `string` | `str` | at most 35 characters |
| `Address2` | Address2 | character | `x(35)` | `string` | `str` | at most 35 characters |
| `City` | City | character | `x(25)` | `string` | `str` | at most 25 characters |
| `State` | State | character | `x(20)` | `string` | `str` | at most 20 characters |
| `PostalCode` | Postal Code | character | `x(10)` | `string` | `str` | at most 10 characters |
| `HomePhone` | Home Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
| `WorkPhone` | Work Phone | character | `x(20)` | `string` | `str` | at most 20 characters |
| `DeptCode` | Dept Code | character | `x(3)` | `string` | `str` | at most 3 characters, must match an existing Department |
| `Position` | Position | character | `x(20)` | `string` | `str` | at most 20 characters |
| `Birthdate` | Birthdate | date | `99/99/9999` | `string` | `date` | ISO date |
| `StartDate` | Start Date | date | `99/99/9999` | `string` | `date` | ISO date |
| `VacationDaysLeft` | Vacation Days Left | integer | `>>9` | `number` | `int` | at least 0, at most 999 |
| `SickDaysLeft` | Sick Days Left | integer | `>>9` | `number` | `int` | at least 0, at most 999 |

## Department `departments`

Primary key: `DeptCode` · Indexes: `DeptCode` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `DeptCode` | Dept Code | character | `x(3)` | `string` | `str` | required, at most 3 characters |
| `DeptName` | Dept Name | character | `x(15)` | `string` | `str` | at most 15 characters |

## Benefits `benefitses`

Primary key: `EmpNum` · Indexes: `EmpNo` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `EmpNum` | Emp No | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing Employee |
| `HealthCare` | Health Care | character | `x(8)` | `string` | `str` | at most 8 characters |
| `LifeInsurance` | Life Insurance | integer | `$>>,>>>,>>>` | `number` | `int` | at least 0, at most 99999999 |
| `Pension401K` | Pension401K | integer | `>>,>>9` | `number` | `int` | at least 0, at most 99999 |
| `StockPurchase` | Stock Purchase | integer | `>>,>>9` | `number` | `int` | at least 0, at most 99999 |
| `MedicalSpending` | Medical Spending | integer | `>>,>>9` | `number` | `int` | at least 0, at most 99999 |
| `DependentCare` | Dependent Care | integer | `>>,>>9` | `number` | `int` | at least 0, at most 99999 |

## Family `families`

Primary key: `EmpNum, RelativeName` · Indexes: `EmpNoRelativeName` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `EmpNum` | Emp No | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing Employee |
| `RelativeName` | Relative Name | character | `x(15)` | `string` | `str` | required, at most 15 characters |
| `Relation` | Relation | character | `x(15)` | `string` | `str` | at most 15 characters |
| `Birthdate` | Birthdate | date | `99/99/9999` | `string` | `date` | ISO date |
| `CoveredOnBenefits` | Covered On Benefits | logical | `yes/no` | `boolean` | `bool` | free text |
| `BenefitDate` | Benefit Date | date | `99/99/9999` | `string` | `date` | ISO date |

## TimeSheet `time-sheets`

Primary key: `EmpNum, DayRecorded` · Indexes: `EmpNoDayRecorded` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `EmpNum` | Emp No | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999, must match an existing Employee |
| `DayRecorded` | Day Recorded | date | `99/99/9999` | `string` | `date` | required, ISO date |
| `TypeRecorded` | Type Recorded | character | `x(8)` | `string` | `str` | at most 8 characters |
| `AMTimeIn` | AM Time In | character | `xx:xx` | `string` | `str` | at most 5 characters |
| `AMTimeOut` | AM Time Out | character | `xx:xx` | `string` | `str` | at most 5 characters |
| `PMTimeIn` | PM Time In | character | `xx:xx` | `string` | `str` | at most 5 characters |
| `PMTimeOut` | PM Time Out | character | `xx:xx` | `string` | `str` | at most 5 characters |
| `RegularHours` | Regular Hours | decimal | `>>9.<<` | `number` | `Decimal` | at least 0, at most 999.99, 2 decimal places |
| `OvertimeHours` | Overtime Hours | decimal | `>>9.<<` | `number` | `Decimal` | at least 0, at most 999.99, 2 decimal places |

## Vacation `vacations`

Primary key: `EmpNum, StartDate` · Indexes: `EmpNoStartDate` (primary) (unique)

| ABL field | Label | ABL type | Format | TypeScript | Pydantic | Validation |
|---|---|---|---|---|---|---|
| `EmpNum` | Emp No | integer | `zzzzzzzzz9` | `number` | `int` | required, at least 0, at most 9999999999 |
| `StartDate` | Start Date | date | `99/99/9999` | `string` | `date` | required, ISO date |
| `EndDate` | End Date | date | `99/99/9999` | `string` | `date` | ISO date |
