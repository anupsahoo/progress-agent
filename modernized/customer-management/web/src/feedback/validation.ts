import type { Feedback } from './types';

// Field rules derived from the ABL FORMAT and VALEXP of each Feedback field.
// Server-side checks in api/app/models/feedback.py enforce the same rules.
export function validateFeedback(v: Partial<Feedback>): Record<string, string> {
  const e: Record<string, string> = {};
  // Contact: FORMAT "x(30)"
  if (typeof v.Contact === 'string' && v.Contact.length > 30) e.Contact = "Contact Name must be at most 30 characters.";
  // Company: FORMAT "x(20)"
  if (typeof v.Company === 'string' && v.Company.length > 20) e.Company = "Company must be at most 20 characters.";
  // EmailAddress: FORMAT "x(50)"
  if (typeof v.EmailAddress === 'string' && v.EmailAddress.length > 50) e.EmailAddress = "Email must be at most 50 characters.";
  if (v.EmailAddress && !/^[^@\s]+@[^@\s]+$/.test(String(v.EmailAddress))) e.EmailAddress = "Email must be a valid e-mail address.";
  // Phone: FORMAT "x(20)"
  if (typeof v.Phone === 'string' && v.Phone.length > 20) e.Phone = "Phone must be at most 20 characters.";
  // Fax: FORMAT "x(20)"
  if (typeof v.Fax === 'string' && v.Fax.length > 20) e.Fax = "Fax must be at most 20 characters.";
  // Comments: FORMAT "x(80)"
  if (typeof v.Comments === 'string' && v.Comments.length > 80) e.Comments = "Comments must be at most 80 characters.";
  // Department: FORMAT "x(15)"
  if (v.Department === undefined || v.Department === null || v.Department.trim() === '') e.Department = "Department is required.";
  if (typeof v.Department === 'string' && v.Department.length > 15) e.Department = "Department must be at most 15 characters.";
  // Rating: FORMAT "9"
  if (typeof v.Rating === 'number' && v.Rating < 0) e.Rating = "Rating must be at least 0.";
  if (typeof v.Rating === 'number' && v.Rating > 9) e.Rating = "Rating must be at most 9.";
  if (typeof v.Rating === 'number' && !Number.isInteger(v.Rating)) e.Rating = "Rating must be a whole number.";
  return e;
}
