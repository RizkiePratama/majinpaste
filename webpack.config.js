const path = require('path');

module.exports = {
  entry: {
    "paste": './app/bundle/majin_paste.js',
  },
  output: {
    path: path.resolve(__dirname,'public'),
    filename: 'bundle/[name].bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          'style-loader',
	  'css-loader',
        ]
      },
      {
        test: /\.(woff|woff2|eot|svg)$/,
        use: [
	  {
	    loader: 'file-loader',
	    options: {
              name: 'fonts/[hash].[ext]',
	    }
	  }
        ]
      },
      {
        test: /\.ttf$/,
        use: [
	  {
	    loader: 'ttf-loader',
	    options: {
              name: 'fonts/[hash].[ext]',
	    }
	  }
        ]
      },
    ]
  }
}
