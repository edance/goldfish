// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

// Import dependencies
import 'phoenix_html';

// Import prism and languages
import 'prismjs';
import 'prismjs/components/prism-elixir';
import 'prismjs/components/prism-ruby';
import 'prismjs/components/prism-bash';

// Local components
import './timestamps';
import './header';
import './chat';
import './message-nav';
import './messagebox';
import './filepicker';
import './slug';
import './nav';

// Turbolinks
import './turbolinks';
