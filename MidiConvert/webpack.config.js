const path = require('path');

module.exports = {
	'context': __dirname,
	entry: './src/musician-midi-converter.js',
	target: 'web',
	output: {
		path: path.resolve(__dirname, './js'),
		filename: 'musician-midi-converter.js',
		library: 'MusicianMidiConverter',
		sourceMapFilename: '[file].map',
		libraryTarget: 'umd',
		globalObject: 'this',
		umdNamedDefine: true,
	},
	devtool: 'source-map',
	module: {
		rules: [
			{
				test: /\.js$/,
				exclude: /(node_modules|bower_components)/,
				use: {
					loader: 'babel-loader',
					options: {
						presets: ["@babel/preset-env"]
					}
				}
			}
		]
	},
};
