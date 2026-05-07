const jwt = require('jsonwebtoken');

/**
 * Middleware que valida o JWT enviado no header Authorization.
 * Espera o formato: "Authorization: Bearer <token>"
 * Em caso de sucesso, popula req.userId com o id do usuário logado.
 */
module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ error: 'Token não fornecido' });
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') {
    return res.status(401).json({ error: 'Token mal formatado' });
  }

  const token = parts[1];

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ error: 'Token inválido ou expirado' });
    }

    req.userId = decoded.id;
    req.userEmail = decoded.email;
    next();
  });
};
