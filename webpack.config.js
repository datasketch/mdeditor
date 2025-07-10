var path = require('path');

module.exports = {
    mode: 'development',
    entry: path.join(__dirname, 'srcjs-shiny', 'markdowneditor.jsx'),
    output: {
        path: path.join(__dirname, 'inst/www/mdeditor/markdowneditor'),
        filename: 'markdowneditor.js'
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                loader: 'babel-loader',
                options: {
                    presets: ['@babel/preset-env', '@babel/preset-react']
                }
            },
            // For CSS so that import "path/style.css"; works
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            }
        ]
    },
    externals: {
        'react': 'window.React',
        'react-dom': 'window.ReactDOM',
        'reactR': 'window.reactR'
    },
    stats: {
        colors: true
    },
    devtool: 'source-map'
};