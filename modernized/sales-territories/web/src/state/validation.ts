import type { State } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each State field.
// Server-side checks in api/app/models/state.py enforce the same rules.
export function validateState(v: Partial<State>): Record<string, string> {
  const e: Record<string, string> = {};
  // State: FORMAT "x(20)"
  if (v.State === undefined || v.State === null || v.State.trim() === '') e.State = "State is required.";
  if (typeof v.State === 'string' && v.State.length > 20) e.State = "State must be at most 20 characters.";
  // StateName: FORMAT "x(20)"
  if (typeof v.StateName === 'string' && v.StateName.length > 20) e.StateName = "State Name must be at most 20 characters.";
  // Region: FORMAT "x(8)"
  if (typeof v.Region === 'string' && v.Region.length > 8) e.Region = "Region must be at most 8 characters.";
  return e;
}
