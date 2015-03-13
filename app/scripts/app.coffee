React = require 'react'

window.React = React

MyComponent = require './components/mycomponent.coffee'

# React.render <MyComponent />, document.getElementById 'content'

slide = remark.create
  sourceUrl         : 'slide.md'
  highlightStyle    : 'solarized_light'
  highlightLanguage : 'remark'
