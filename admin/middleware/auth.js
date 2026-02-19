function isAuthenticated(req, res, next) {
  if (req.session.logged_in) return next();
  res.redirect("/admin");
}

module.exports = { isAuthenticated };

