// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
var readData = {
  user: null
  // user: {id: 'id1', name: 'alice', email: 'alice@oneskyapp.com'}
};
Elm.Main.embed( document.getElementById( 'main' ), readData );
