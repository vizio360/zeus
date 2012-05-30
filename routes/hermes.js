exports.GET = function(req, res, next)
{
  var hermesId = req.params.id;
  if (hermesId)
  {
      res.send("hermes instance id = "+hermesId);
  }
  else
  {
      next();
  }
};

