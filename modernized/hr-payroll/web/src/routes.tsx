// HR & Payroll: module routes. Replaces hr_menu.w.
import { useState } from 'react';
import { EmployeeList } from './employee/EmployeeList';
import { EmployeeDetail } from './employee/EmployeeDetail';
import { EmployeeEdit } from './employee/EmployeeEdit';
import type { Employee } from './employee/types';
import { DepartmentList } from './department/DepartmentList';
import { DepartmentDetail } from './department/DepartmentDetail';
import { DepartmentEdit } from './department/DepartmentEdit';
import type { Department } from './department/types';
import { BenefitsList } from './benefits/BenefitsList';
import { BenefitsDetail } from './benefits/BenefitsDetail';
import { BenefitsEdit } from './benefits/BenefitsEdit';
import type { Benefits } from './benefits/types';
import { FamilyList } from './family/FamilyList';
import { FamilyDetail } from './family/FamilyDetail';
import { FamilyEdit } from './family/FamilyEdit';
import type { Family } from './family/types';
import { TimeSheetList } from './timeSheet/TimeSheetList';
import { TimeSheetDetail } from './timeSheet/TimeSheetDetail';
import { TimeSheetEdit } from './timeSheet/TimeSheetEdit';
import type { TimeSheet } from './timeSheet/types';
import { VacationList } from './vacation/VacationList';
import { VacationDetail } from './vacation/VacationDetail';
import { VacationEdit } from './vacation/VacationEdit';
import type { Vacation } from './vacation/types';

function EmployeeScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Employee | null>(null);
  if (mode === 'view' && row) return <EmployeeDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <EmployeeEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <EmployeeEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <EmployeeList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function DepartmentScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Department | null>(null);
  if (mode === 'view' && row) return <DepartmentDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <DepartmentEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <DepartmentEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <DepartmentList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function BenefitsScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Benefits | null>(null);
  if (mode === 'view' && row) return <BenefitsDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <BenefitsEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <BenefitsEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <BenefitsList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function FamilyScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Family | null>(null);
  if (mode === 'view' && row) return <FamilyDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <FamilyEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <FamilyEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <FamilyList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function TimeSheetScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<TimeSheet | null>(null);
  if (mode === 'view' && row) return <TimeSheetDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <TimeSheetEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <TimeSheetEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <TimeSheetList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

function VacationScreen() {
  const [mode, setMode] = useState<'list' | 'view' | 'edit' | 'new'>('list');
  const [row, setRow] = useState<Vacation | null>(null);
  if (mode === 'view' && row) return <VacationDetail row={row} onBack={() => setMode('list')} onEdit={() => setMode('edit')} />;
  if (mode === 'edit' && row) return <VacationEdit initial={row} isNew={false} onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('view')} />;
  if (mode === 'new') return <VacationEdit initial={{}} isNew onSaved={(r) => { setRow(r); setMode('view'); }} onCancel={() => setMode('list')} />;
  return <VacationList onOpen={(r) => { setRow(r); setMode('view'); }} onNew={() => setMode('new')} />;
}

export const hrPayrollRoutes = [
  { path: '/hr-payroll/employees', title: "Employee maintenance", element: <EmployeeScreen /> },
  { path: '/hr-payroll/departments', title: "Department maintenance", element: <DepartmentScreen /> },
  { path: '/hr-payroll/benefitses', title: "Benefits maintenance", element: <BenefitsScreen /> },
  { path: '/hr-payroll/families', title: "Family maintenance", element: <FamilyScreen /> },
  { path: '/hr-payroll/time-sheets', title: "TimeSheet maintenance", element: <TimeSheetScreen /> },
  { path: '/hr-payroll/vacations', title: "Vacation maintenance", element: <VacationScreen /> },
];
