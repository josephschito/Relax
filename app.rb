require './relax.rb'

include Relax

background = Relax::Background.new

`setInterval(function(){#{background.update}}, 50)`
