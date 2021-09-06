// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import 'phoenix_html';

// Import prism and languages
import 'prismjs';
import 'prismjs/components/prism-elixir';
import 'prismjs/components/prism-ruby';
import 'prismjs/components/prism-bash';

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".
import './timestamps';
import './header';
import './chat';
import './message-nav';
import './messagebox';
import './filepicker';
import './slug';
