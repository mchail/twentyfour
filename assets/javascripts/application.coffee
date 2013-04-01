
$ ->
	run = ->
		nums = $('#nums').val().split(/[^\d]+/).join(',')
		$.get('/solve?n=' + nums, (data) ->
			window.data = data
			$answers = $('.answers')
			$answers.empty()
			data.forEach((val) ->
				$answers.append($('<li>').text(val))
			)
			if data.length == 0
				$answers.append($('<p>').text('no results'))
		)
	$('form').submit ->
		run()
		return false
