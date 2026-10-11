export interface Customer {
  custNum: number;
  name: string;
  address: string;
  city: string;
  state: string;
  postalCode: string;
  phone: string;
}

export type EditableField = Exclude<keyof Customer, 'custNum'>;
export const EDITABLE: EditableField[] = ['name', 'address', 'city', 'state', 'postalCode', 'phone'];
