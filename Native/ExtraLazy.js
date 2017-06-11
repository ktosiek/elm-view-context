var _user$project$Native_ExtraLazy = function() {
  // Straigt from elm-lang/virtual-dom
  function thunk(func, args, thunk)
  {
  	return {
  		type: 'thunk',
  		func: func,
  		args: args,
  		thunk: thunk,
  		node: undefined
  	};
  }

  function lazy4(fn, a, b, c, d)
  {
  	return thunk(fn, [a,b,c,d], function() {
  		return A4(fn, a, b, c, d);
  	});
  }

  function lazy5(fn, a, b, c, d, e)
  {
  	return thunk(fn, [a,b,c,d,e], function() {
  		return A5(fn, a, b, c, d, e);
  	});
  }

  return {
    lazy4: F5(lazy4),
    lazy5: F6(lazy5),
  }
}();
