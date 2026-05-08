/**
 * Utilitários de validação
 */

const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

const validateAmount = (amount) => {
  return typeof amount === 'number' && amount > 0;
};

const validateDate = (date) => {
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
  if (!dateRegex.test(date)) return false;
  const d = new Date(date);
  return d instanceof Date && !isNaN(d);
};

const validateString = (str, minLength = 1, maxLength = 500) => {
  if (typeof str !== 'string') return false;
  const trimmed = str.trim();
  return trimmed.length >= minLength && trimmed.length <= maxLength;
};

const validatePassword = (password) => {
  if (typeof password !== 'string') return false;
  if (password.length < 6) return false;
  if (password.length > 100) return false;
  return true;
};

module.exports = {
  validateEmail,
  validateAmount,
  validateDate,
  validateString,
  validatePassword
};
