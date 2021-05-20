require 'opal/jquery'
require './relax.rb'

include Relax

Document.ready? do
  background = Relax::Background.new

  `setInterval(function(){#{background.update}}, 50)`
end
