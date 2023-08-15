const webpack = require('webpack');

module.exports = {
  // ...その他の設定...
  plugins: [
    new webpack.ContextReplacementPlugin(
      /moment[\/\\]locale$/, // 正規表現パターン
      /ja/ // デフォルトの言語
    ),
    // ...他のプラグイン...
  ],
};
